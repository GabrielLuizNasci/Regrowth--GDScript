extends FadingBulletin
class_name GameOverMenu

@onready var restart_button: UIButton = $VBoxContainer/RestartButton
@onready var main_menu_button: UIButton = $VBoxContainer/MainMenuButton
@onready var exit_button: UIButton = $VBoxContainer/ExitButton

func _ready() -> void:
	restart_button.modulate = TRANSPARENT_COLOR
	main_menu_button.modulate = TRANSPARENT_COLOR
	exit_button.modulate = TRANSPARENT_COLOR
	
	get_tree().paused = true
	
	super()

func fade_in() -> void:
	super()
	
	var tween := create_tween()
	tween.tween_property(restart_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(main_menu_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(exit_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)

func _on_restart_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.BurnedForest)

func _on_main_menu_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
