extends Node

@onready var stamina_recovery_timer: Timer = %StaminaRecoveryTimer

@export var max_health := 100.0
@export var max_energy := 100.0
@export var stamina_recovery_value := 2000.0
@export var stamina_recovery_delay := 1.0

var current_health := max_health
var current_energy := max_energy
var is_recovering_stamina := false

func _enter_tree() -> void:
	EventSystem.PLA_change_energy.connect(change_energy)
	EventSystem.PLA_change_health.connect(change_health)
	

func _process(delta: float) -> void:
	if is_recovering_stamina and current_energy < max_energy:
		change_energy(stamina_recovery_value * delta)
	elif current_energy >= max_energy and is_recovering_stamina:
		_stop_stamina_recovery()

func change_energy(energy_change : float) -> void:
	_stop_stamina_recovery()
	
	current_energy += energy_change
	
	if current_energy <= 0:
		EventSystem.PLA_stamina_empty.emit()
		_start_stamina_recovery()
	
	current_energy = clampf(current_energy, 0, max_energy)
	EventSystem.PLA_energy_updated.emit(max_energy, current_energy)
	
	if current_energy > 0:
		stamina_recovery_timer.start(stamina_recovery_delay)
		EventSystem.PLA_stamina_refilled.emit()

func _pause_stamina_recovery() -> void:
	is_recovering_stamina = false
	stamina_recovery_timer.stop()

func _start_stamina_recovery() -> void:
	is_recovering_stamina = true

func _stop_stamina_recovery() -> void:
	is_recovering_stamina = false
	stamina_recovery_timer.stop()

func change_health(health_change: float) -> void:
	current_health += health_change
	current_health = clampf(current_health, 0, max_health)
	EventSystem.PLA_health_updated.emit(max_health, current_health)
	
	if current_health <= 0:
		EventSystem.PLA_freeze_player.emit()
		#EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)
