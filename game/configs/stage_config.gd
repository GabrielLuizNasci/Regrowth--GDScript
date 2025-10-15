class_name StageConfig

enum Keys{
	TestStage,
	MainMenu,
	BurnedForest,
	RainingForest,
	BoitatasLair
}

const STAGE_PATHS := {
	Keys.MainMenu: "res://stages/main_menu/main_menu.tscn",
	Keys.BurnedForest: "res://stages/burned_forest/burned_forest.tscn",
	Keys.RainingForest: "res://stages/raining_forest/rainy_forest.tscn",
	Keys.BoitatasLair: "res://stages/snake_lair/snake_lair.tscn"
}

static func get_stage(key: Keys) -> Stage:
	return load(STAGE_PATHS.get(key)).instantiate()
