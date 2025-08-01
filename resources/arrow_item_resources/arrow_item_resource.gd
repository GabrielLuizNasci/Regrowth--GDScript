extends ItemResource

class_name ArrowItemResource

enum ElementType {
	WIND,
	FIRE,
	NATURE, # Mudar o nome para algo mais condizente depois
	WATER
}

@export var arrow_element_type: ElementType = ElementType.WIND
@export var arrow_speed := 15.0
@export var arrow_damage := 15.0
