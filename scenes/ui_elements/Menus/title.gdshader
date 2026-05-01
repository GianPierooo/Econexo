shader_type canvas_item;

// Parámetros ajustables desde el Inspector
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 2.0) = 0.5;
uniform float speed : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Un pulso suave y constante
    float flare = sin(TIME * speed) * 0.5 + 0.5;
    
    // Aplicamos el brillo sutilmente solo a las partes visibles del título
    vec3 bright_effect = tex_color.rgb + (glow_color.rgb * intensity * flare);
    
    COLOR = vec4(bright_effect, tex_color.a);
}