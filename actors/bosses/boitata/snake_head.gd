extends CharacterBody3D

class_name SnakeHead

enum States {
	Wander,
	Attack,
	Hurt,
	Lunge,
	Dead
}

var state := States.Wander

#Temporizadores
@onready var wander_timer: Timer = %WanderTimer
@onready var agressive_timer: Timer = %AgressiveTimer
@onready var disappear_after_death_timer: Timer = %DisappearAfterDeathTimer

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

@export var normal_speed := 3.0
@export var chase_speed := 6.0
@export var turn_speed_weight := 0.1
@export var damage := 30.0
@export var vision_range := 20.0
@export var vision_fov := 60.0
