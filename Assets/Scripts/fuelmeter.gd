# fuel_gauge.gd
extends Sprite2D

@export var max_fuel := 100.0
var fuel := max_fuel

@export var consumption_rate := 0.4   # fuel per second when accelerating
@export var regen_rate := 3.0          # optional: fuel gained when idle (or set to 0)
 
@export var full_angle := 90.0         # degrees (pointing right)
@export var empty_angle := -90.0       # degrees (pointing left)

@onready var needle := $Needle         # adjust path if needed

func _process(delta):
	# Fuel consumption
	if Input.is_action_pressed("accelerate") and fuel > 0:
		fuel = max(0.0, fuel - consumption_rate * delta)
	#/else:                                          
		# regen when not accelerating (optional)
	#	fuel = min(max_fuel, fuel + regen_rate * delta)

	# Calculate percent (0..1)
	var p := fuel / max_fuel

	# Lerp rotation from empty → full
	var target_angle = lerp(empty_angle, full_angle, p)

	# Smooth rotation using linear interpolation
	needle.rotation_degrees = lerp(needle.rotation_degrees, target_angle, 8.0 * delta)
