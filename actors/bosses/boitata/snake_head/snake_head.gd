extends CharacterBody3D

class_name SerpentHead

const ANIM_BLEND = 0.2
const GRAVITY := 2.0

enum States {
	Chase,
	Search,
	Attack,
	Hurt,
	Dead
}

var state := States.Chase

@onready var search_timer: Timer = %SearchTimer
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var nav_agent = $NavigationAgent3D
@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var attack_hit_area: Area3D = $AttackHitArea
@onready var eyes_marker: Marker3D = $EyesMarker
@onready var vision_area_collision_shape: CollisionShape3D = $VisionArea/CollisionShape3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var chase_speed := 8.0
@export var max_health := 50
@export var turn_speed_weight := 0.1
@export var min_search_time := 1.0
@export var max_search_time := 3.0
@export var attack_distance = 2.0
@export var damage := 20.0
@export var vision_range := 15.0
@export var vision_fov := 80.0

var player_in_vision_range := false
var last_seen_player_position: Vector3
@onready var health := max_health

func _ready() -> void:
	# Ajuste o tamanho da área de visão para o valor exportado
	vision_area_collision_shape.shape.radius = vision_range
	if animation_player:
		animation_player.animation_finished.connect(animation_finished)

func animation_finished(_anim_name: String) -> void:
	if state == States.Hurt:
		set_state(States.Chase)
	if state == States.Attack:
		set_state(States.Chase)

func _physics_process(_delta: float) -> void:
	if state == States.Chase:
		chase_loop()
	elif state == States.Search:
		search_loop()
	elif state == States.Attack:
		attack_loop()
	# Os estados Hurt e Dead não precisam de loop, pois a animação cuida do fluxo.

func chase_loop() -> void:
	if not can_see_player():
		last_seen_player_position = player.global_position
		set_state(States.Search)
		return
	
	look_forward()
	
	if global_position.distance_to(player.global_position) <= attack_distance:
		set_state(States.Attack)
		return
	
	nav_agent.target_position = player.global_position
	var direction := global_position.direction_to(nav_agent.get_next_path_position())
	direction.y = 0
	velocity.x = direction.normalized().x * chase_speed
	velocity.z = direction.normalized().z * chase_speed
	apply_gravity()
	move_and_slide()

func search_loop() -> void:
	apply_gravity()
	if can_see_player():
		set_state(States.Chase)
		return
	
	look_forward()
	
	nav_agent.target_position = last_seen_player_position
	var direction := global_position.direction_to(nav_agent.get_next_path_position())
	direction.y = 0
	velocity.x = direction.normalized().x * chase_speed
	velocity.z = direction.normalized().z * chase_speed
	
	if global_position.distance_to(last_seen_player_position) < 1.0:
		set_state(States.Chase)
	
	move_and_slide()

func attack_loop() -> void:
	var direction := global_position.direction_to(player.global_position)
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z) + PI, turn_speed_weight)
	
	if global_position.distance_to(player.global_position) > attack_distance and not can_see_player():
		last_seen_player_position = player.global_position
		set_state(States.Search)
		return
	
	move_and_slide()

func apply_gravity() -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY
	else:
		velocity.y = 0

func look_forward() -> void:
	if velocity.length_squared() > 0.01:
		rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z) + PI, turn_speed_weight)

func attack() -> void:
	if player in attack_hit_area.get_overlapping_bodies():
		EventSystem.PLA_change_health.emit(-damage)

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
		States.Search:
			search_timer.start(randf_range(min_search_time, max_search_time))
			#animation_player.play("Search")
		States.Hurt:
			search_timer.stop()
			animation_player.play("HitReact", ANIM_BLEND)
		States.Chase:
			search_timer.stop()
			#animation_player.play("Gallop")
		States.Attack:
			animation_player.play("Attack", ANIM_BLEND)
		States.Dead:
			queue_free() # ou tocar animação de morte, etc.

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
