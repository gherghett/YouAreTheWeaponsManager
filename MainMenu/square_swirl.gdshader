shader_type canvas_item;

uniform float scroll_speed : hint_range(0, 2) = 0.08;
uniform float angle_degrees : hint_range(0, 360) = 45.0;
uniform float repeat_x : hint_range(1, 20) = 20;
uniform float repeat_y : hint_range(1, 20) = 12;
uniform float row_offset : hint_range(0, 1) = 1;
uniform sampler2D texture_to_scroll;
uniform float time = 0.0;
uniform float brightness_cutoff = 0.5;
uniform float alpha_of_darkness = 1.0;

const float spin_ease = 1.0;
const float spin_amount = 0.50;

uniform float bottom_right_darkness : hint_range(0, 5) = 3.5; // Adjust darkness in the bottom right.
uniform float contrast_intensity : hint_range(1, 5) = 1.5;    // Contrast multiplier for bottom right.

void fragment() {
    highp float uv_len = length(UV);
    float angle_rad = radians(angle_degrees);

    vec2 direction = vec2(cos(angle_rad), sin(angle_rad));

    vec2 offset_uv = UV - (time * scroll_speed * direction);

    float offset = fract(floor(offset_uv.y * repeat_y) * 0.5) > 0.0 ? (row_offset * 0.324) : 0.0;

    offset_uv.x += offset;

    vec2 scaled_uv = vec2(fract(offset_uv.x * repeat_x),
                fract(offset_uv.y * repeat_y));

    vec2 texelSize = vec2(1.0) / vec2(textureSize(texture_to_scroll, 0));
    vec2 uv = round(scaled_uv / texelSize) * texelSize;

    highp float speed = (spin_amount * spin_ease * 0.2);
    speed = time * speed;
    speed += 302.2;

    highp float new_pixel_angle = (atan(uv.y, uv.x)) + speed - spin_ease * 20. * (1. * spin_amount * uv_len + (1. - 1. * spin_amount));
    highp vec2 mid = (TEXTURE_PIXEL_SIZE.xy / length(TEXTURE_PIXEL_SIZE.xy)) / 2.;
    uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

    vec4 col = texture(texture_to_scroll, uv);
    float brightness = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722));

    // Calculate gradient factor based on UV proximity to the bottom-right corner.
    float gradient_factor = UV.x * UV.y;

    // Adjust darkness and contrast using the gradient factor.
    float darkness = mix(1.0, bottom_right_darkness, gradient_factor); // Darker as we approach bottom-right.
    float contrast = mix(1.0, contrast_intensity, gradient_factor);    // Higher contrast as we approach bottom-right.

    brightness *= darkness; // Apply darkness.
    col.rgb = (col.rgb - 0.5) * contrast + 0.5; // Apply contrast.

    if (brightness < brightness_cutoff) {
        col.a = alpha_of_darkness;
    }
    COLOR = col;
}
