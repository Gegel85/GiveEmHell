extends Node2D

var velocity = Vector2(0,0)
const speed = 350
const focusedSpeed = 200
var deadZone = 0.2
var instance

func _ready():
	instance = instance_from_id(get_instance_id())

func spawnAt(pos):
	instance.set_pos(pos)

func moveAround(obj, nb):
	velocity = Vector2(0, 0)
	var horizontal = Input.get_joy_axis(nb, JOY_AXIS_0)
	var vertical = Input.get_joy_axis(nb, JOY_AXIS_1)
	if abs(horizontal) < deadZone:
		horizontal = 0
	if abs(vertical) < deadZone:
		vertical = 0
	var actualSpeed = 0
	if Input.is_joy_button_pressed(nb, JOY_L3):
		actualSpeed = focusedSpeed
		$Core.visible = true
	else:
		actualSpeed = speed
		$Core.visible = false
	velocity.y = vertical * actualSpeed
	velocity.x = horizontal * actualSpeed

	obj.move_and_slide(velocity)
