extends Node

class_name BulletinConfig

enum  Keys {
	InteractionPrompt,
	PauseMenu,
	GameOverMenu,
	SettingsMenu
}

const BULLETIN_PATHS := {
	Keys.InteractionPrompt: "res://bulletins/interaction_prompt/interaction_prompt.tscn",
	Keys.PauseMenu: "res://bulletins/pause_menu/pause_menu.tscn",
	Keys.GameOverMenu: "res://bulletin/game_over_menu/game_over_menu.tscn",
	Keys.SettingsMenu: "res://bulletins/settings_menu/settings_menu.tscn"
}

static func get_bulletin(key : Keys) -> Bulletin:
	return load(BULLETIN_PATHS.get(key)).instantiate()
