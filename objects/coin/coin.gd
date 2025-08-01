extends Area3D

const rot_speed: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg_to_rad(rot_speed))
	#if(has_overlapping_bodies()):
		#queue_free()

func _on_body_entered(body):
	queue_free()
