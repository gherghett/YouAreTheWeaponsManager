shader_type canvas_item;

#define PI 3.14159265359

float vmin(vec2 v) {
    return min(v.x, v.y);
}

float vmax(vec2 v) {
    return max(v.x, v.y);
}

float ellip(vec2 p, vec2 s) {
    float m = vmin(s);
    return (length(p / s) * m) - m;
}

float halfEllip(vec2 p, vec2 s) {
    p.x = max(0.0, p.x);
    float m = vmin(s);
    return (length(p / s) * m) - m;
}

float fBox(vec2 p, vec2 b) {
    return vmax(abs(p) - b);
}

float dvd_d(vec2 p) {
    float d = halfEllip(p, vec2(0.8, 0.5));
    d = max(d, -p.x - 0.5);
    float d2 = halfEllip(p, vec2(0.45, 0.3));
    d2 = max(d2, min(-p.y + 0.2, -p.x - 0.15));
    d = max(d, -d2);
    return d;
}

float dvd_v(vec2 p) {
    vec2 pp = p;
    p.y += 0.7;
    p.x = abs(p.x);
    vec2 a = normalize(vec2(1, -0.55));
    float d = dot(p, a);
    float d2 = d + 0.3;
    p = pp;
    d = min(d, -p.y + 0.3);
    d2 = min(d2, -p.y + 0.5);
    d = max(d, -d2);
    d = max(d, abs(p.x + 0.3) - 1.1);
    return d;
}

float dvd_c(vec2 p) {
    p.y += 0.95;
    float d = ellip(p, vec2(1.8, 0.25));
    float d2 = ellip(p, vec2(0.45, 0.09));
    d = max(d, -d2);
    return d;
}

float dvd(vec2 p) {
    p.y -= 0.345;
    p.x -= 0.035;
    p *= mat2(vec2(1.0, -0.2), vec2(0, 1));
    float d = dvd_v(p);
    d = min(d, dvd_c(p));
    p.x += 1.3;
    d = min(d, dvd_d(p));
    p.x -= 2.4;
    d = min(d, dvd_d(p));
    return d;
}

float range(float vmin, float vmax, float value) {
    return (value - vmin) / (vmax - vmin);
}

float rangec(float a, float b, float t) {
    return clamp(range(a, b, t), 0.0, 1.0);
}

vec3 pal(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

vec3 spectrum(float n) {
    return pal(n, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(1.0, 1.0, 1.0), vec3(0.0, 0.33, 0.67));
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.x;
    uv = (uv - 0.5) * 2.0; // Normalized screen space

    float t = TIME;
    vec2 dir = normalize(vec2(9.0, 16.0));
    vec2 move = dir * t / 1.5;

    vec4 col = vec4(1, 1, 1, 0);

    float logoScale = 0.1;
    vec2 logoSize = vec2(2.0, 0.85) * logoScale;

    vec2 size = vec2(2.0) - logoSize * 2.0;
    move = move / size + 0.5;

    for (int i = 0; i < 5; i++) {
        vec2 hitPos = move;

        if (i > 0) {
            hitPos -= 0.00001 / size;
        }

        hitPos = (hitPos - 0.5) * size;
        col.rgb = vec3(1.0) - col.rgb;
        col.rgb /= 3.0;
    }

    float d = dvd((uv - move) / logoScale);
    d /= fwidth(d);
    d = 1.0 - clamp(d, 0.0, 1.0);
    col.rgb = mix(col.rgb, vec3(1.0), d);

    col.rgb = pow(col.rgb, vec3(1.0 / 1.5));
    col.a = col.a * 0.5 + 0.5;
    COLOR = col;
}
