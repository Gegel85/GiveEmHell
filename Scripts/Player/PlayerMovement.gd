extends Node2D

var velocity = Vector2(0,0)
const speed = 350
const focusedSpeed = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func moveAround(obj):
	velocity = Vector2(0, 0)

	var horizontal = (Input.get_action_strength("right") - Input.get_action_strength("left"))
	var vertical = (Input.get_action_strength("down") - Input.get_action_strength("up"))
	var actualSpeed = 0
	if Input.is_action_pressed("focus"):
		actualSpeed = focusedSpeed
		$Core.visible = true
	else:
		actualSpeed = speed
		$Core.visible = false
	velocity.y = vertical * actualSpeed
	velocity.x = horizontal * actualSpeed

	obj.move_and_slide(velocity)
