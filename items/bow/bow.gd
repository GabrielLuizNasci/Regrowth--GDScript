extends Node3D

@onready var arrow_spawn_point: Node3D = $ArrowSpawnPoint

var current_arrow_element_key: ItemConfig.Keys = ItemConfig.Keys.WindArrow

func _ready() -> void:
	EventSystem.BOW_shoot_arrow.connect(shoot_arrow)
	EventSystem.BOW_change_element.connect(set_arrow_element)

func get_arrow_spawn_point() -> Node3D:
	return arrow_spawn_point

func set_arrow_element(new_element_key: ItemConfig.Keys) -> void:
	if ItemConfig.ARROW_ELEMENT_PATHS.has(new_element_key):
		current_arrow_element_key = new_element_key
		print("Elemento da flecha alterado para: ", new_element_key)
		# Opcional: Atualizar alguma indicação visual no arco (ex: cor, brilho)
	else:
		print("Erro! Elemento de flecha inválido: ", new_element_key)

func shoot_arrow() -> void:
	# Verifica se há uma cena de flecha configurada para o elemento atual
	if not ItemConfig.ARROW_ELEMENT_PATHS.has(current_arrow_element_key):
		print("Nenhuma flecha configurada para o elemento: ", current_arrow_element_key)
		return
	var arrow_scene: PackedScene = ItemConfig.get_arrow_element(current_arrow_element_key)
	
	if arrow_scene:
		var instance = arrow_scene.instantiate()
		instance.position = arrow_spawn_point.global_position
		instance.transform.basis = arrow_spawn_point.global_transform.basis
		get_tree().current_scene.add_child(instance)
		
		print("Flecha de ", current_arrow_element_key, " disparada!")
	else:
		print("Erro ao carregar a cena da flecha para o elemento: ", current_arrow_element_key)

func _on_change_arrow_element_received(new_element_key: ItemConfig.Keys) -> void:
	set_arrow_element(new_element_key)
