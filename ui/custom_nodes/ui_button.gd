extends Button
class_name UIButton

func _ready() -> void:
	pressed.connect(clicked)

func clicked() -> void:
	pass
