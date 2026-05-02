shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 3;
uniform float intensity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 color_tint : source_color = vec4(0.0, 0.8, 1.0, 1.0);

void fragment() {
    vec2 uv = UV;
    
    // Distorsión ondulatoria
    uv.x += sin(uv.y * 20.0 + TIME * speed) * intensity * 0.02;
    uv.y += cos(uv.x * 20.0 + TIME * speed) * intensity * 0.02;
    
    vec4 tex = texture(TEXTURE, uv);
    
    // Pulso de energía
    float pulse = sin(TIME * speed * 2.0) * 0.5 + 0.5;
    
    // Bordes brillantes
    float edge_x = abs(UV.x - 0.5) * 2.0;
    float edge_y = abs(UV.y - 0.5) * 2.0;
    float edge = max(edge_x, edge_y);
    float glow = smoothstep(0.6, 1.0, edge) * pulse;
    
    // Mezclar con color de teletransporte
    tex.rgb += color_tint.rgb * glow * intensity;
    tex.rgb += color_tint.rgb * pulse * 0.05;
    
    COLOR = tex;
}