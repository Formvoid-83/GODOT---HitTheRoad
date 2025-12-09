shader_type canvas_item;

uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform float h_offset = 0.0;

void fragment() {
    vec2 uv = UV * uv_scale;
    uv.x = fract(uv.x + h_offset);
    COLOR = texture(TEXTURE, uv);
}
