shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(0.3, 0.0, 0.5, 0.25); // violeta
uniform float speed : hint_range(0.0, 1.0) = 0.05;
uniform float scale : hint_range(1.0, 20.0) = 6.0;

void fragment() {
    vec2 uv = UV * scale + vec2(TIME * speed, TIME * speed * 0.6);
    
    // Ruido simple con senos (no necesita textura)
    float n = sin(uv.x * 3.1 + sin(uv.y * 2.7)) * 0.5 + 0.5;
    n *= sin(uv.y * 2.3 + sin(uv.x * 3.5 + TIME * 0.3)) * 0.5 + 0.5;
    
    COLOR = vec4(fog_color.rgb, fog_color.a * n);
}