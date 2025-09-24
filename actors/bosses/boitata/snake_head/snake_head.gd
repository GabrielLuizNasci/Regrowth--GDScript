extends CharacterBody3D

class_name SerpentHead

const ANIM_BLEND = 0.2
const GRAVITY := 2.0

enum States {
	Patrol,
	Chase,
	Hurt,
	Dead
}

var state := States.Patrol

#Temporizadores
@onready var agressive_timer: Timer = %AgressiveTimer
@onready var disappear_after_death_timer: Timer = %DisappearAfterDeathTimer
@onready var patrol_timer: Timer = %PatrolTimer

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var nav_agent = $NavigationAgent3D
@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var attack_hit_area: Area3D = $AttackHitArea
@onready var eyes_marker: Marker3D = $EyesMarker
@onready var vision_area_collision_shape: CollisionShape3D = $VisionArea/CollisionShape3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var normal_speed := 5.0
@export var chase_speed := 10.0
@export var max_health := 100
@export var turn_speed_weight := 0.1
@export var min_patrol_time := 2.0
@export var max_patrol_time := 4.0
@export var attack_distance = 2.0
@export var damage := 20.0
@export var vision_range := 15.0
@export var vision_fov := 80.0

var player_in_vision_range := false
@onready var health := max_health

func _ready() -> void:
	vision_area_collision_shape.shape.radius = vision_range
	pick_patrol_velocity()
	if animation_player:
		animation_player.animation_finished.connect(animation_finished)

func animation_finished(_anim_name: String) -> void:
	if state == States.Hurt:
		set_state(States.Chase)

func _physics_process(_delta: float) -> void:
	if state == States.Patrol:
		patrol_loop()
	elif state == States.Chase:
		chase_loop()

func patrol_loop() -> void:
	if can_see_player():
		set_state(States.Chase)
		return
	
	look_forward()
	apply_gravity()
	move_and_slide()

func chase_loop() -> void:
	if not can_see_player():
		set_state(States.Patrol)
		return
	
	look_forward()
	nav_agent.target_position = player.global_position
	var direction := global_position.direction_to(nav_agent.get_next_path_position())
	direction.y = 0
	velocity.x = direction.normalized().x * chase_speed
	velocity.z = direction.normalized().z * chase_speed
	apply_gravity()
	move_and_slide()

func apply_gravity() -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY
	else:
		velocity.y = 0

func look_forward() -> void:
	if velocity.length_squared() > 0.01:
		rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z) + PI, turn_speed_weight)

func pick_patrol_velocity() -> void:
	var direction := Vector2(0, -1).rotated(randf() * PI * 2)
	velocity = Vector3(direction.x, 0, direction.y) * normal_speed

func take_hit(arrow_item_resource : ArrowItemResource) -> void:
	health -= arrow_item_resource.arrow_damage
	
	if state != States.Dead and health <= 0:
		set_state(States.Dead)
	elif not state in [States.Dead]:
		set_state(States.Hurt)

func set_state(new_state : States) -> void:
	if state == new_state:
		return
	state = new_state
	match state:
		States.Patrol:
			pick_patrol_velocity()
			patrol_timer.start(randf_range(min_patrol_time, max_patrol_time))
		States.Hurt:
			patrol_timer.stop()
			#animation_player.play("HitReact", ANIM_BLEND)
		States.Chase:
			patrol_timer.stop()
			#animation_player.play("Gallop")
		States.Dead:
			queue_free() 

func player_in_fov() -> bool:
	if not player:
		return false
	
	var direction_to_player := global_position.direction_to(player.global_position)
	var forward := -global_transform.basis.z
	return direction_to_player.angle_to(forward) <= deg_to_rad(vision_fov)

func player_in_los() -> bool:
	if not player:
		return false
	
	var query_params := PhysicsRayQueryParameters3D.new()
	query_params.from = eyes_marker.global_position
	query_params.to = player.global_position + Vector3(0, 1.5, 0)
	query_params.collision_mask = 1 + 64 # Use a máscara de colisão correta para o ambiente
	var space_state := get_world_3d().direct_space_state
	var result := space_state.intersect_ray(query_params)
	
	return result.is_empty()

func can_see_player() -> bool:
	return player_in_vision_range and player_in_fov() and player_in_los()

func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = true

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = false

func _on_patrol_timer_timeout() -> void:
	pick_patrol_velocity()
	patrol_timer.start(randf_range(min_patrol_time, max_patrol_time))
