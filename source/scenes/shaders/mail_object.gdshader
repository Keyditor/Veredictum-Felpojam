shader_type canvas_item;

// Cor da outline (branco)
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Largura da outline
uniform float width : hint_range(0.0, 10.0) = 7.0;
// Padrão de borda (mais preciso para pixel art)
uniform int pattern : hint_range(0, 2) = 0; // 0: Diamond, 1: Circle, 2: Square

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * width;
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Verifica pixels vizinhos
    float alpha = texture_color.a;
    alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
    
    // Padrão Square (mais robusto)
    if (pattern == 2) {
        alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
    }
    
    // Define a cor da borda apenas em pixels transparentes
    vec4 col = texture(TEXTURE, UV);
    vec4 outline = outline_color;
    outline.a = min(alpha, 1.0) - col.a;
    
    // Mistura o sprite original com a outline
    COLOR = mix(col, outline, outline.a);
}
