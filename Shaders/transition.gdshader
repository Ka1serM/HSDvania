shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D MASK_TEXTURE;
uniform vec2 player_screen_pos = vec2(0.5, 0.5);
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float pixel_size : hint_range(1.0, 320.0) = 70.0; 
uniform float mask_pixel_size : hint_range(1.0, 320.0) = 70.0;
uniform vec3 tint_color : source_color = vec3(0.567, 0.361, 0.361);
uniform float blur_amount : hint_range(0.0, 10.0) = 5.0;

// Sample texture with edge clamping
float safe_sample(sampler2D tex, vec2 uv) {
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        return 0.0; // Return transparent if out of bounds
    } else {
        return texture(tex, uv).a;
    }
}

void fragment() {
    float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;

    // Foreground
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Mask UV with smooth scaling
    vec2 mask_uv = SCREEN_UV - player_screen_pos;
    float smooth_progress = smoothstep(0.0, 1.0, progress);
    mask_uv = mask_uv / ((1.0 - smooth_progress) * 7.0);
    mask_uv.x /= aspect;
    mask_uv += player_screen_pos;
    mask_uv = clamp(mask_uv, vec2(0.0), vec2(1.0));

    // Background UV with pixelation
    vec2 background_uv = SCREEN_UV - vec2(0.5); // Shift origin to center
    vec2 scaling = SCREEN_PIXEL_SIZE / 0.0005 * smooth_progress;
    background_uv = floor(background_uv * pixel_size / scaling) / (pixel_size / scaling);
    background_uv += vec2(0.5); // Shift back to original position
    background_uv = clamp(background_uv, vec2(0.0), vec2(1.0));

    // Pixelated Background
    vec4 pixelated_screen_color = texture(SCREEN_TEXTURE, background_uv);

    // Tint Effect
    vec3 tinted_background = mix(pixelated_screen_color.rgb * tint_color * 2.0, vec3(0.0), smooth_progress);

    // Pixelate Mask with smooth scaling
    vec2 mask_scaling = SCREEN_PIXEL_SIZE / 0.0010;
    float mask_pixel_size_animated = mask_pixel_size + smooth_progress * -(mask_pixel_size / 2.0);
    vec2 pixelated_mask_uv = floor(mask_uv * mask_pixel_size_animated / mask_scaling) / (mask_pixel_size_animated / mask_scaling);
    pixelated_mask_uv = clamp(pixelated_mask_uv, vec2(0.0), vec2(1.0));

    float pixelated_mask = safe_sample(MASK_TEXTURE, pixelated_mask_uv);

    // Blur Mask Effect
    vec2 tex_offset = blur_amount * SCREEN_PIXEL_SIZE;
    float blurred_mask = 0.0;
    float weight_sum = 0.0;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * tex_offset;
            vec2 sample_uv = pixelated_mask_uv + offset;

            blurred_mask += safe_sample(MASK_TEXTURE, sample_uv);
            weight_sum += 1.0;
        }
    }

    if (weight_sum > 0.0)
        blurred_mask /= weight_sum;

    // Final color mix
    COLOR = vec4(mix(tinted_background.rgb, screen_color.rgb, blurred_mask), 1.0);
}
