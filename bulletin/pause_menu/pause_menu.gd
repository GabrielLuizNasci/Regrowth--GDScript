extends FadingBulletin

@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
	resume_button.modulate = TRANSPARENT_COLOR
	settings_button.modulate = TRANSPARENT_COLOR
	main_menu_button.modulate = TRANSPARENT_COLOR
	exit_button.modulate = TRANSPARENT_COLOR
	
	get_tree().paused = true
	
	super()

func fade_in() -> void:
	super()
	
	var tween := create_tween()
	tween.tween_property(resume_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(settings_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(main_menu_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)
	tween.tween_property(exit_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)

func _on_resume_button_pressed() -> void:
	EventSystem.HUD_show_hud.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	fade_out()

func _on_settings_button_pressed() -> void:
	pass

func _on_main_menu_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
