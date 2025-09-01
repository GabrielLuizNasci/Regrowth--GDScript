extends ItemResource

class_name BuffItemResource

enum BuffType {
	HEALTH,
	ENERGY,
}

@export var buff_type: BuffType = BuffType.HEALTH
@export var buff_value := 10.0
