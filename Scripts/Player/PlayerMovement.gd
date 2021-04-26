extends Node2D

var velocity = Vector2(0,0)
const speed = 350
export var focused = false
const focusedSpeed = 200
var deadZone = 0.2
var instance

func _ready():
	instance = instance_from_id(get_instance_id())

func spawnAt(pos):
	instance.set_pos(pos)

func moveAround(obj, nb):
	velocity = Vector2(0, 0)
	var horizontal = Input.get_action_strength("right_" + str(nb)) - Input.get_action_strength("left_" + str(nb))
	var vertical = Input.get_action_strength("down_" + str(nb)) - Input.get_action_strength("up_" + str(nb))
	if abs(horizontal) < deadZone:
		horizontal = 0
	if abs(vertical) < deadZone:
		vertical = 0
	var actualSpeed = 0
	if Input.is_action_pressed("focus_" + str(nb)):
		focused = true
		actualSpeed = focusedSpeed
		$Core.visible = true
	else:
		focused = false
		actualSpeed = speed
		$Core.visible = false
	velocity.y = vertical * actualSpeed
	velocity.x = horizontal * actualSpeed

	obj.move_and_slide(velocity)
