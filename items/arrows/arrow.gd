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
		# Para o futuro
		# if has_node("Mesh"):
		# 	var mesh_node = get_node("Mesh") as MeshInstance3D
		# 	if element_type == ArrowItemResource.ArrowElementType.WIND:
		# 		mesh_node.material_override = load("res://materials/wind_arrow_material.tres")
		# 	elif element_type == ArrowItemResource.ArrowElementType.FIRE:
		# 		mesh_node.material_override = load("res://materials/fire_arrow_material.tres")
	else:
		# Fallback para caso o resource não seja atribuído
		initial_speed = 20.0
		element_type = ArrowItemResource.ElementType.WIND
		damage = 10.0

func _physics_process(delta: float) -> void:
	self.velocity = -transform.basis.z * initial_speed
	move_and_slide()
	
	
	# Exemplo simples de detecção de colisão e destruição da flecha
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Flecha colidiu com: ", collision.get_collider().name)
		
		# Exemplo: Se colidir com um inimigo, aplique dano e destrua a flecha
		if collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(damage, element_type)
		
		queue_free() # Destrói a flecha após colidir
		return

# Adicione aqui a lógica de interação com inimigos baseada no 'element_type'
# Por exemplo, uma função para ser chamada pelos inimigos quando atingidos.
