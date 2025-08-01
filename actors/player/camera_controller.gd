extends Node3D

var camroot_h := 0.0
var camroot_v := 0.0
@export var cam_v_max := 75
@export var cam_v_min := -55
var h_sensitivity := 0.01
var v_sensitivity := 0.01
var h_acceleration := 2.5
var v_acceleration := 2.5

func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	camroot_v = clamp(camroot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	get_node("H").rotation.y = lerpf(get_node("H").rotation.y, camroot_h, delta * h_acceleration)
	get_node("H/V").rotation.x = lerpf(get_node("H/V").rotation.x, camroot_v, delta * v_acceleration)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camroot_h += -event.relative.x * h_sensitivity
		camroot_v += -event.relative.y * v_sensitivity
