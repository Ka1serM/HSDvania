shader_type canvas_item;

uniform float width : hint_range(0.0, 64) = 5;
uniform vec3 outline_color : source_color = vec3(0.0, 0.0, 0.0);

uniform vec2 pixel_count = vec2(64.0);

uniform bool is_hit;
uniform float hit_flicker_speed : hint_range(1, 100) = 10.0;
uniform float cycle_speed : hint_range(1.0, 50.0) = 15.0; // Controls color cycle speed

const vec3 hit_colors[3] = vec3[](
    vec3(0.0, 0.0, 0.0), // Black
    vec3(0.8, 0.8, 0.8), // Dark White
    vec3(1.0, 0.0, 0.0) // Red
);

// Pixelation function
vec2 pixelate(vec2 uv) {
    uv *= pixel_count;
    uv = floor(uv) / pixel_count;
    return uv;
}

// Outline function
float outline(sampler2D texture, vec2 uv, float outline_width) {
    if (outline_width == 0.0) return 0.0;

    vec2 unit = 1.0 / vec2(textureSize(texture, 0));
    float alpha_sum = 0.0;

    // Loop through surrounding pixels with pixelated offsets
    for (float x = -floor(outline_width); x <= floor(outline_width); x++) {
        for (float y = -floor(outline_width); y <= floor(outline_width); y++) {
            if (x == 0.0 && y == 0.0) continue; // Skip the center pixel

            vec2 offset = vec2(x * unit.x, y * unit.y);
            vec2 neighborUV = pixelate(uv + offset);

            if (texture(texture, neighborUV).a > 0.0) {
                alpha_sum += 1.0;
            }
        }
    }

    return clamp(alpha_sum, 0.0, 1.0);
}

// Get current cycling hit color
vec3 get_hit_color() {
    int index = int(mod(TIME * cycle_speed * 10.0, float(hit_colors.length())));
    return hit_colors[index];
}

// Hit effect intensity (blinking)
float hit_effect() {
    if (!is_hit)
		return 0.0;
    return 0.5 + 0.5 * sin(TIME * hit_flicker_speed);
}

void fragment() {
    vec2 pixelUV = pixelate(UV);
    vec4 pixel_color = texture(TEXTURE, UV);

    if (pixel_color.a == 0.0) {
        // Draw outline if pixel is transparent
        pixel_color.rgb = outline_color;
        pixel_color.a = outline(TEXTURE, UV, width);
    } else {
        // Apply new hit effect cycling through Red, Dark White, Dark Red, Grey, Black, and Blue
        vec3 current_hit_color = get_hit_color();
        pixel_color.rgb = mix(pixel_color.rgb, current_hit_color, hit_effect());
    }

    COLOR = pixel_color;
}
