extends Node3D

const CAMERA_MAX_PITCH: float = deg_to_rad(70)
const CAMERA_MIN_PITCH: float = deg_to_rad(-89.9)
const CAMERA_RATIO: float = .625

@export var mouse_sensitivity: float = .002
@export var mouse_y_inversion: float = -1.0

@onready var _camera_yaw: Node3D = self
@onready var _camera_pitch: Node3D = %Arm
@onready var camera: Camera3D = %Camera3D

var target: Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	if target:
		look_at_target(delta)
	elif Input.is_action_just_pressed("toggle_lock") and target == null:
		reset_camera_to_front(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_camera(event.relative)
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("toggle_lock"):
		if target:
			target = null
		else:
			toggle_lock()

func rotate_camera(p_relative:Vector2) -> void:
	_camera_yaw.rotation.y -= p_relative.x * mouse_sensitivity
	_camera_yaw.orthonormalize()
	_camera_pitch.rotation.x += p_relative.y * mouse_sensitivity * CAMERA_RATIO * mouse_y_inversion 
	_camera_pitch.rotation.x = clamp(_camera_pitch.rotation.x, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)

func toggle_lock(cam_lock: bool = false):
	target = null if cam_lock else camera.get_nearest_visible_target(target)

func look_at_target(delta: float) -> void:
	var to_target = (target.global_position - global_position).normalized()
	var target_yaw = atan2(to_target.x, to_target.z)
	# Interpolação
	_camera_yaw.rotation.y = lerp_angle(_camera_yaw.rotation.y, target_yaw, delta * 5.0)
	# Pitch
	var camera_position = camera.global_position
	var pitch_direction = (target.global_position - camera_position).normalized()
	var pitch_angle = -asin(pitch_direction.y)
	_camera_pitch.rotation.x = lerp_angle(_camera_pitch.rotation.x, pitch_angle, delta * 5.0)

func reset_camera_to_front(delta: float) -> void:
	var target_yaw = 0.0  # Frente do jogador (ajuste se necessário)
	var target_pitch = 0.0
	
	_camera_yaw.rotation.y = lerp_angle(_camera_yaw.rotation.y, target_yaw, delta * 5.0)
	_camera_pitch.rotation.x = lerp_angle(_camera_pitch.rotation.x, target_pitch, delta * 5.0)
