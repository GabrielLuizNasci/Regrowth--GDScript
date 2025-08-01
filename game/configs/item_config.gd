extends Node

class_name ItemConfig

enum Keys {
	
	Wind,
	Water,
	Fire,
	Nature,
	Bow,
	Whip,
	
	#Flechas
	WindArrow,
	FireArrow,
	NatureArrow,
	WaterArrow
}

const ITEM_RESOURCE_PATHS := {
	# Flechas
	Keys.WindArrow: "res://resources/arrow_item_resources/wind_arrow_resource.tres",
	Keys.FireArrow: "res://resources/arrow_item_resources/fire_arrow_resource.tres",
	Keys.NatureArrow: "res://resources/arrow_item_resources/nature_arrow_resource.tres",
	Keys.WaterArrow: "res://resources/arrow_item_resources/water_arrow_resource.tres"
	
}

const ARROW_ELEMENT_PATHS := {
	# Flechas
	Keys.WindArrow: "res://items/arrows/wind_arrow/wind_arrow.tscn" ,
	Keys.FireArrow: "res://items/arrows/fire_arrow/fire_arrow.tscn",
	Keys.NatureArrow: "res://items/arrows/nature_arrow/nature_arrow.tscn",
	Keys.WaterArrow: "res://items/arrows/water_arrow/water_arrow.tscn"
}

static func get_arrow_element(item_key : Keys) -> PackedScene:
	return load(ARROW_ELEMENT_PATHS.get(item_key))
