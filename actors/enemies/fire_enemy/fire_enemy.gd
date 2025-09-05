extends BaseEnemy

class_name FireEnemy

var is_enhanced := false

var initial_normal_speed: float
var initial_chase_speed: float
var initial_max_health: int
var initial_damage: float

const enhanced_multiplier := 1.5

func _ready() -> void:
	initial_normal_speed = normal_speed
	initial_chase_speed = chase_speed
	initial_max_health = max_health
	initial_damage = damage
	
	super._ready()

func take_hit(arrow_item_resource: ArrowItemResource) -> void:
	match arrow_item_resource.arrow_element_type:
		ArrowItemResource.ElementType.WIND:
			if not is_enhanced:
				_apply_strengthening_effects()
				is_enhanced = true
			return
		
		ArrowItemResource.ElementType.WATER:
			if is_enhanced:
				_revert_strengthening_effects()
				is_enhanced = false
			else:
				set_state(States.Dead)
				return
		ArrowItemResource.ElementType.FIRE:
			return
		_: 
			super.take_hit(arrow_item_resource)

func _apply_strengthening_effects() -> void:
	normal_speed = initial_normal_speed * enhanced_multiplier
	chase_speed = initial_chase_speed * enhanced_multiplier
	health = int(initial_max_health * enhanced_multiplier)
	damage = initial_damage * enhanced_multiplier
	print("Inimigo de fogo foi fortalecido!")

func _revert_strengthening_effects() -> void:
	# Reverte os atributos do inimigo para os valores iniciais.
	normal_speed = initial_normal_speed
	chase_speed = initial_chase_speed
	health = initial_max_health
	damage = initial_damage
	print("Inimigo de fogo teve seus poderes revertidos.")
