shader_type canvas_item;

uniform bool hit;
uniform float flicker_speed : hint_range(1, 100);
uniform float cycle_speed : hint_range(0.1, 10.0) = 1.0;
uniform float mix_ratio = 1.0;

const vec3 colors[6] = vec3[] (
    vec3(1.0, 0.0, 0.0), // Red
    vec3(0.5, 0.0, 0.0), // Dark red
    vec3(0.0, 0.0, 0.0), // Black
    vec3(0.0, 0.0, 1.0), // Blue
    vec3(0.0, 0.0, 0.5), // Dark blue
    vec3(0.0, 0.0, 0.0)  // Black
);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    if (texture_color.a == 0.0)
        discard;

    // Flicker effect
    float flash = 0.5 + 0.5 * sin(TIME * flicker_speed);
    vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0);

    // Cycling colors using time
    int color_index = int(mod(TIME * cycle_speed, float(colors.length())));
    vec3 cycle_color = colors[color_index];

    // Blend with texture and flicker
    vec3 final_color = mix(texture_color.rgb, cycle_color, mix_ratio);
    final_color = mix(final_color, flash_color.rgb, flash * float(hit));

    COLOR = vec4(final_color, texture_color.a);
}