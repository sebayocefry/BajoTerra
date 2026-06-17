shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.5) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    float dist = distance(UV, center);

    float glow = smoothstep(radius, radius + 0.2, dist);

    vec3 color = vec3(2.0, 2.0, 2.0); // lava

    float alpha = 1.0 - glow;

    if (radius <= 0.01) {
        alpha = 0.0;
    }

    COLOR = vec4(color, alpha);
}