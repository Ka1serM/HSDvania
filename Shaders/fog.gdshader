shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D MASK_TEXTURE; // Cloud mask texture
uniform sampler2D NOISE_TEXTURE; // Noise texture
uniform vec2 player_screen_pos = vec2(0.5, 0.5); // Default: center of screen
uniform float progress : hint_range(0.0, 1.0) = 1.0; // Controls mask expansion
uniform float pixel_size : hint_range(1.0, 320.0) = 16.0;
uniform vec3 color : source_color = vec3(0.0, 1.0, 0.5); // Tint color

void fragment() {
    // Get screen aspect ratio to avoid stretching
    float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;

    // --- Foreground (Unpixelated) ---
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // --- Mask UV Calculation ---
    vec2 mask_uv = SCREEN_UV - player_screen_pos;
    mask_uv = mask_uv / ((1.0 - progress) * 5.0);
    mask_uv.x /= aspect;  // Correct for aspect ratio
    mask_uv += player_screen_pos;
    mask_uv = clamp(mask_uv, vec2(0.0), vec2(1.0)); // Clamp *before* pixelation

    // --- Background UV Calculation (Pixelated) ---
    vec2 background_uv = SCREEN_UV;
	vec2 scaling = SCREEN_PIXEL_SIZE / 0.0010;
    background_uv = floor(background_uv * pixel_size / scaling) / (pixel_size / scaling);
    background_uv = clamp(background_uv, vec2(0.0), vec2(1.0));

    // --- Pixelated Background Sampling ---
    vec4 pixelated_screen_color = texture(SCREEN_TEXTURE, background_uv);

    // --- Apply Tint to Pixelated Background ---
    //  Convert vec3 color to vec4 for mixing (alpha = 1.0)
    vec4 tinted_background = mix(pixelated_screen_color, vec4(color, 1.0), 0.8);

    // --- Sample the Mask ---
    // Apply pixelation to the mask UVs
    vec2 mask_scaling = SCREEN_PIXEL_SIZE / 0.0010;
    vec2 pixelated_mask_uv = floor(mask_uv * pixel_size / mask_scaling) / (pixel_size / mask_scaling);
    pixelated_mask_uv = clamp(pixelated_mask_uv, 0.0, 1.0);
    float mask = texture(MASK_TEXTURE, pixelated_mask_uv).a;

    // --- Noise for Animation ---
    vec2 noise_uv = mask_uv + vec2(TIME * 0.05, TIME * 0.05); // Animate noise
    float noise_value = texture(NOISE_TEXTURE, noise_uv).r;

    // --- Apply Noise to Mask ---
    float animated_mask = mask + (noise_value - 0.5) * 0.1;

    // --- Animate Progress ---
    float animated_progress = 0.5 + 0.5 * sin(TIME * 0.5);

    // --- Final Visibility ---
    float visibility = animated_mask * animated_progress;
	visibility = clamp(visibility, 0.0, 1.0); //Ensure proper values.


    // --- Final Blending ---
	// Combine pixelated and original background, apply screen color based on visibility.
    COLOR = mix(tinted_background, screen_color, visibility);
}