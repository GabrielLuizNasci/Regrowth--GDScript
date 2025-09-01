extends CharacterBody3D

class_name Arrow

@export var arrow_resource: ArrowItemResource

var initial_speed: float
var element_type: ArrowItemResource.ElementType
var damage: float

func _ready() -> void:
	if arrow_resource:
		initial_speed = arrow_resource.arrow_speed
		element_type = arrow_resource.arrow_element_type
		damage = arrow_resource.arrow_damage
	else:
		# Fallback para caso o resource não seja atribuído
		initial_speed = 20.0
		element_type = ArrowItemResource.ElementType.WIND
		damage = 10.0

func _physics_process(delta: float) -> void:
	self.velocity = -transform.basis.z * initial_speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Flecha colidiu com: ", collision.get_collider().name)
		
		if collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(damage, element_type)
		
		queue_free() # Destrói a flecha após colidir
		return
