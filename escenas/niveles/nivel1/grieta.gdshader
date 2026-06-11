shader_type canvas_item;

uniform vec4 crack_color : source_color = vec4(1.0, 0.4, 0.0, 1.0); // naranja/lava
uniform float speed : hint_range(0.0, 2.0) = 0.3;
uniform float intensity : hint_range(0.0, 1.0) = 0.6;
uniform float crack_size : hint_range(1.0, 30.0) = 12.0;

void fragment() {
    vec2 uv = UV * crack_size;

    // Patrón de grietas con funciones de onda
    float t = TIME * speed;
    float crack = abs(sin(uv.x * 2.1 + sin(uv.y * 1.7 + t)));
    crack *= abs(sin(uv.y * 2.4 + sin(uv.x * 1.3 - t * 0.7)));
    
    // Solo muestra las líneas finas (las grietas)
    float glow = pow(1.0 - crack, 8.0) * intensity;
    
    COLOR = vec4(crack_color.rgb, glow);
}