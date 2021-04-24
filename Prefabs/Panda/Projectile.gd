extends KinematicBody2D

export var direction = 0
export var spawn_pos = Vector2.ZERO
export var speed = 400
export var distance_max = 500
var vector

func _process(delta):
	vector = Vector2(cos(direction), sin(direction))
	move_and_slide(vector  * speed)
	if (spawn_pos.distance_to(position) > distance_max):
		queue_free()
