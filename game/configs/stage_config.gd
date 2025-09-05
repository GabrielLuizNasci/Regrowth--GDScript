class_name StageConfig

enum Keys{
	TestStage,
	MainMenu,
	BurnedForest,
	BoitatasLair
}

const STAGE_PATHS := {
	Keys.MainMenu: "res://stages/main_menu/main_menu.tscn",
	Keys.BurnedForest: "res://stages/burned_forest/burned_forest.tscn",
}

static func get_stage(key: Keys) -> Stage:
	return load(STAGE_PATHS.get(key)).instantiate()
