shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float time_speed = 1.0;
uniform float wave_strength = 0.92;
uniform vec4 water_color : source_color = vec4(0.2, 0.5, 0.8, 0.6);
uniform vec4 deep_water_color : source_color = vec4(0.9, 0.5, 0.8, 0.6);


void fragment() {
    float noise = texture(noise_texture, UV).r;

    vec2 distorted_uv = UV + (vec2(noise, noise) - 0.5) * wave_strength;

    vec4 base_color = texture(TEXTURE, distorted_uv);

    // Blend based on noise threshold
    if (noise > 0.4) {
        COLOR = mix(base_color, water_color, 1.0);
    } else {
        COLOR = mix(base_color, deep_water_color, 1.0);
    }
}
