extends Node3D

class_name BowManager

@onready var bow_arm: SpringArm3D = %BowArm
@onready var bow: Node3D = %Bow
@onready var camera_manager: Node3D = $"../CameraManager"

@export var bow_rotation_speed := 10.0

var is_locked_on := false
var current_lock_on_target: Node3D = null

func _ready() -> void:
	if not bow or not camera_manager:
		push_error("Bow Node ou Camera Manager Node não foram atribuídos no BowController.")
		set_process(false)

func _physics_process(delta: float) -> void:
	if not is_locked_on:
		var camera_target_transform = camera_manager.camera.global_transform
		global_transform.basis = global_transform.basis.slerp(camera_target_transform.basis, delta * bow_rotation_speed)
	else:
		if is_instance_valid(current_lock_on_target):
			var target_position = current_lock_on_target.global_position
			
			var target_look_at_transform = global_transform.looking_at(target_position, Vector3.UP)
			global_transform.basis = global_transform.basis.slerp(target_look_at_transform.basis, delta * bow_rotation_speed)
		else:
			toggle_lock_on(false)

func toggle_lock_on(enable: bool, target: Node3D = null) -> void:
	is_locked_on = enable
	current_lock_on_target = target
	
	if not is_locked_on:
		print("Trava de alvo desativada.")
		EventSystem.CAM_clear_lock_on_target.emit()
	else:
		if is_instance_valid(target):
			print("Trava de alvo ativada no alvo: ", target.name)
			EventSystem.CAM_set_lock_on_target.emit(target)
		else:
			print("Tava de alvo ativado sem alvo válido.")
			is_locked_on = false
			EventSystem.CAM_clear_lock_on_target.emit()
