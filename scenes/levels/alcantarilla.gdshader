shader_type canvas_item;

// Estas variables con 'uniform' van a aparecer en el Inspector para que juegues con los valores
uniform vec2 direccion_velocidad = vec2(0.2, 0.0); // Hacia dónde y qué tan rápido se mueve
uniform float fuerza_olas = 0.02; // Qué tanto se deforma el agua
uniform float velocidad_olas = 3.0; // Qué tan rápido se mueven las olas

void fragment() {
    // Agarramos las coordenadas de la textura original
    vec2 textura_uv = UV;
    
    // 1. Efecto de corriente: Movemos la textura constantemente con el tiempo
    textura_uv.x += TIME * direccion_velocidad.x;
    textura_uv.y += TIME * direccion_velocidad.y;
    
    // 2. Efecto de olas: Usamos una onda senoidal para deformarla un poco arriba y abajo
    textura_uv.y += sin(UV.x * 20.0 + TIME * velocidad_olas) * fuerza_olas;
    
    // Le aplicamos los cambios al color final que se dibuja en pantalla
    COLOR = texture(TEXTURE, textura_uv);
}