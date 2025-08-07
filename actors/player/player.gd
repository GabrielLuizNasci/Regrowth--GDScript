extends CharacterBody3D

@export var normal_speed := 5.0
@export var sprint_speed := 7.5
@export var jump_speed := 4.5
@export var jump_count := 0
@export var max_jump := 2
@export var gravity := 0.2

@onready var bow_manager: BowManager = $BowManager
@onready var bow: Node3D = $BowManager/Bow
@onready var body: MeshInstance3D = %Body


var last_movement_dir := Vector3.BACK
var is_grounded := true
var is_sprinting := false

func _physics_process(delta: float) -> void:
	move()
	
	if(Input.is_action_just_pressed("attack")):
		EventSystem.BOW_shoot_arrow.emit()
		EventSystem.PLA_change_energy.emit(-5.0)

func move() -> void:
	var direction: Vector3 = get_camera_relative_input()
	
	if Input.is_action_just_pressed("jump") and jump_count <= max_jump:
		velocity.y = jump_speed
		jump_count += 1
	
	if is_on_floor():
		jump_count = 0
		is_sprinting = Input.is_action_pressed("sprint")
		
		if not is_grounded:
			is_grounded = true
	else:
		velocity.y -= gravity
		is_sprinting = false
		
		if is_grounded:
			is_grounded = false
	
	var speed := normal_speed if not is_sprinting else sprint_speed
	
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	
	if direction.length() > 0.1:
		last_movement_dir = direction
	
	var target_angle := Vector3.BACK.signed_angle_to(last_movement_dir, Vector3.UP)
	body.global_rotation.y = target_angle
	
	move_and_slide()

func get_camera_relative_input() -> Vector3:
	var input_dir: Vector3 = Vector3.ZERO
	if Input.is_key_pressed(KEY_A): # Left
		input_dir -= %Camera3D.global_transform.basis.x
	if Input.is_key_pressed(KEY_D): # Right
		input_dir += %Camera3D.global_transform.basis.x
	if Input.is_key_pressed(KEY_W): # Forward
		input_dir -= %Camera3D.global_transform.basis.z
	if Input.is_key_pressed(KEY_S): # Backward
		input_dir += %Camera3D.global_transform.basis.z
	return input_dir

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("summon"):
		bow.visible = !bow.visible
	
	if event.is_action_pressed("arrow_element_up"):
		EventSystem.BOW_change_element.emit(ItemConfig.Keys.WindArrow)
	elif event.is_action_pressed("arrow_element_left"):
		EventSystem.BOW_change_element.emit(ItemConfig.Keys.FireArrow)
	elif event.is_action_pressed("arrow_element_right"):
		EventSystem.BOW_change_element.emit(ItemConfig.Keys.WaterArrow)
	elif event.is_action_pressed("arrow_element_down"):
		EventSystem.BOW_change_element.emit(ItemConfig.Keys.NatureArrow)
	
	if event.is_action_pressed("lock_on_toggle"):
		if bow_manager.is_locked_on:
			bow_manager.toggle_lock_on(false)
		else:
			print("Nenhum inimigo encontrado para travar.")
	
	if event.is_action_released("ui_accept"):
		velocity.y = 0
