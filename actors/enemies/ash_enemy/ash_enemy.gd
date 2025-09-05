extends BaseEnemy

class_name AshEnemy

func take_hit(arrow_item_resource : ArrowItemResource) -> void:
	match arrow_item_resource.arrow_element_type:
		ArrowItemResource.ElementType.WIND:
			set_state(States.Dead)
			return
		ArrowItemResource.ElementType.FIRE:
			return 
		_: # Caso padrão (qualquer outra flecha)
			# Chama a função take_hit do script base para aplicar o dano padrão.
			super.take_hit(arrow_item_resource)
