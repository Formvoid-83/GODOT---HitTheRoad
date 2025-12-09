shader_type canvas_item;

uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform float v_offset = 0.0;

void fragment() {
    vec2 uv = UV * uv_scale;
    uv.y = fract(uv.y + v_offset);
    COLOR = texture(TEXTURE, uv);
}

