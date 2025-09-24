extends ColorRect

class_name GameFadeController

@export var animation_player: AnimationPlayer

func _enter_tree() -> void:
	EventSystem.GAM_game_fade_in.connect(fade_in)
	EventSystem.GAM_game_fade_out.connect(fade_out)

func fade_in(fade_time: float, maybe_callback = null, show_loading_label = false) -> void:
	mouse_filter = MOUSE_FILTER_STOP
	
	var tween := create_tween()
	tween.tween_property(self, "color", Color.BLACK, fade_time)
	
	if maybe_callback is Callable:
		tween.tween_callback(maybe_callback)
	
	if show_loading_label:
		tween.tween_callback(animation_player.play.bind("loading_animation"))

func fade_out(fade_time: float, maybe_callback = null) -> void:
	var tween := create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 0), fade_time)
	
	if maybe_callback is Callable:
		tween.tween_callback(maybe_callback)
	
	animation_player.play("RESET")
	
	tween.finished.connect(_on_fade_out_finished)

func _on_fade_out_finished() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
