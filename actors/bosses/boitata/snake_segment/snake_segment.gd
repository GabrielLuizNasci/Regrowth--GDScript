extends CharacterBody3D
class_name SerpentSegment

@export var target_node: Node3D
@export var follow_distance := 1.5
@export var normal_speed := 10.0
@export var turn_speed_weight := 0.1
@export var damage := 20.0
@export var knockback_force := 10.0

@onready var colision_area: Area3D = $ColisionArea

var current_position: Vector3
var target_position: Vector3

func _ready():
	if target_node:
		current_position = target_node.global_position
		global_position = current_position

func _physics_process(delta: float) -> void:
	if not target_node:
		return
	var direction = target_node.global_position - global_position
	var distance_to_target = direction.length()
	
	if distance_to_target <= follow_distance:
		velocity = Vector3.ZERO
	else:
		velocity = direction.normalized() * (distance_to_target - normal_speed) * normal_speed
	
	if not is_on_floor():
		velocity.y -= 2.0
	else:
		velocity.y = 0
	
	#var max_segment_speed = target_node.normal_speed * 1.5 
	#if velocity.length() > max_segment_speed:
		#velocity = velocity.normalized() * max_segment_speed
	move_and_slide()
	
	if velocity.length_squared() > 0.01:
		rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z) + PI, turn_speed_weight)

func _on_colision_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var push_direction = (body.global_position - global_position).normalized()
		EventSystem.PLA_change_health.emit(-25)
