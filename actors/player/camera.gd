extends Camera3D

func get_nearest_visible_target(current_target: Node3D = null) -> Node3D:
	var nearest_target: Node3D
	var shortest_distance := INF
	
	for target in get_tree().get_nodes_in_group("Enemy"):
		if not target.is_inside_tree() or not target.visible:
			continue
		var distance := global_position.distance_to(target.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_target = target
		
	return nearest_target
