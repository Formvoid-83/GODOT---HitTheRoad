# main_scroll.gd - attach to Main (Node2D)
extends Node2D

@export var player_speed := 300.0         # change in Inspector to speed up/down
@export var speed_multiplier := 0.008
@export var sky_multiplier := 0.001

@onready var street := $"Street" if has_node("Street") else null
@onready var sky := $"Sky" if has_node("Sky") else null

var road_offset := 0.0
var sky_offset := 0.0

const ROAD_SHADER := """
shader_type canvas_item;
uniform float v_offset = 0.0;
uniform vec2 uv_scale = vec2(1.0,1.0);
void fragment() {
    vec2 uv = UV * uv_scale;
    uv.y = fract(uv.y + v_offset);
    COLOR = texture(TEXTURE, uv);
}
"""

const SKY_SHADER := """
shader_type canvas_item;
uniform float h_offset = 0.0;
uniform vec2 uv_scale = vec2(1.0,1.0);
void fragment() {
    vec2 uv = UV * uv_scale;
    uv.x = fract(uv.x + h_offset);
    COLOR = texture(TEXTURE, uv);
}
"""

func _ready():
	# sanity checks
	print("main_scroll ready. street:", street != null, " sky:", sky != null)

	if not street:
		push_error("Street node NOT found at $Street. Attach this script to the node that is parent of Street/Sky.")
		return
	if not sky:
		push_error("Sky node NOT found at $Sky. Attach this script to the node that is parent of Street/Sky.")
		return

	# create ShaderMaterial at runtime if missing (so you can test immediately)
	if not (street.material and street.material is ShaderMaterial):
		var sm = ShaderMaterial.new()
		var sh = Shader.new()
		sh.code = ROAD_SHADER
		sm.shader = sh
		street.material = sm
		print("Assigned Road ShaderMaterial to Street.")
	else:
		print("Street already had a ShaderMaterial.")

	if not (sky.material and sky.material is ShaderMaterial):
		var sm2 = ShaderMaterial.new()
		var sh2 = Shader.new()
		sh2.code = SKY_SHADER
		sm2.shader = sh2
		sky.material = sm2
		print("Assigned Sky ShaderMaterial to Sky.")
	else:
		print("Sky already had a ShaderMaterial.")

	# optional: verify texture repeat - print resource paths
	if street.texture:
		print("Street texture:", street.texture.resource_path)
	if sky.texture:
		print("Sky texture:", sky.texture.resource_path)

func _process(delta):
	# update offsets from player_speed
	road_offset += player_speed * speed_multiplier * delta
	sky_offset += player_speed * sky_multiplier * delta

	if street.material and street.material is ShaderMaterial:
		street.material.set_shader_parameter("v_offset", road_offset)
	if sky.material and sky.material is ShaderMaterial:
		sky.material.set_shader_parameter("h_offset", sky_offset)
