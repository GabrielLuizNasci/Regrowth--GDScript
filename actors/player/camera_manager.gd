extends Node3D

const CAMERA_MAX_PITCH: float = deg_to_rad(70)
const CAMERA_MIN_PITCH: float = deg_to_rad(-89.9)
const CAMERA_RATIO: float = .625

@export var mouse_sensitivity := .002
@export var mouse_y_inversion := -1.0
@export var lock_on_speed := 8.0

@onready var _camera_yaw: Node3D = self
@onready var _camera_pitch: Node3D = %Arm
@onready var camera: Camera3D = %Camera3D

var lock_on_target: Node3D = null
var is_locked_on: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	EventSystem.CAM_set_lock_on_target.connect(_on_set_lock_on_target)
	EventSystem.CAM_clear_lock_on_target.connect(_on_clear_lock_on_target)

func _process(delta: float) -> void:
	if is_locked_on and is_instance_valid(lock_on_target):
		look_at_lock_on_target(delta)
	else:
		if is_locked_on and not is_instance_valid(lock_on_target):
			_on_clear_lock_on_target()
		pass

func _input(event: InputEvent) -> void:
	if not is_locked_on and event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_camera(event.relative)
		get_viewport().set_input_as_handled()
		return

func rotate_camera(p_relative:Vector2) -> void:
	_camera_yaw.rotation.y -= p_relative.x * mouse_sensitivity
	_camera_yaw.orthonormalize()
	_camera_pitch.rotation.x += p_relative.y * mouse_sensitivity * CAMERA_RATIO * mouse_y_inversion 
	_camera_pitch.rotation.x = clamp(_camera_pitch.rotation.x, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)

func _on_set_lock_on_target(target_node: Node3D) -> void:
	lock_on_target = target_node
	is_locked_on = true

func _on_clear_lock_on_target() -> void:
	lock_on_target = null
	is_locked_on = false

func look_at_lock_on_target(delta: float) -> void:
	if not is_instance_valid(lock_on_target):
		_on_clear_lock_on_target()
		return
	
	var to_target = (lock_on_target.global_position - global_position).normalized()
	var target_yaw = atan2(to_target.x, to_target.z)
	
	_camera_yaw.rotation.y = lerp_angle(_camera_yaw.rotation.y, target_yaw, delta * lock_on_speed)
	
	# Pitch (eixo X)
	var camera_position = camera.global_position
	var pitch_direction = (lock_on_target.global_position - camera_position).normalized()
	var pitch_angle = -asin(pitch_direction.y)
	_camera_pitch.rotation.x = lerp_angle(_camera_pitch.rotation.x, pitch_angle, delta * lock_on_speed)
