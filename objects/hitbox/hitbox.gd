extends Area3D

signal register_hit

func take_hit(arrow_item_resource: ArrowItemResource) -> void:
	register_hit.emit(arrow_item_resource)
