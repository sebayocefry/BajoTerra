shader_type canvas_item;

uniform vec4 color_rayo : source_color = vec4(0.5, 0.6, 1.0, 1.0);
uniform float velocidad : hint_range(0.0, 3.0) = 1.5;
uniform float intensidad : hint_range(0.0, 1.0) = 0.9;

float hash(vec2 p) {
    p = fract(p * vec2(234.34, 435.345));
    p += dot(p, p + 34.23);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash(i), hash(i + vec2(1,0)), f.x),
        mix(hash(i + vec2(0,1)), hash(i + vec2(1,1)), f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += a * noise(p);
        p *= 2.1;
        a *= 0.5;
    }
    return v;
}

void fragment() {
    vec2 uv = UV;
    float t = TIME * velocidad;
    float rayos = 0.0;

    for (int i = 0; i < 6; i++) {
        float xi = float(i) * 0.18 + 0.05;
        
        // Cada rayo parpadea en momento distinto
        float flash = step(0.93, sin(t * (2.5 + float(i) * 1.3) + float(i) * 5.7));
        
        // La trayectoria del rayo se tuerce con ruido (simula ramificación)
        float torcido = xi + (fbm(vec2(uv.y * 4.0 + float(i) * 7.0, t)) - 0.5) * 0.12;
        
        float dist = abs(uv.x - torcido);
        
        // Línea brillante + halo
        float bolt = exp(-dist * 120.0) * flash;
        bolt += exp(-dist * 25.0) * 0.4 * flash;
        
        rayos += bolt;
    }

    COLOR = vec4(color_rayo.rgb, rayos * intensidad);
}