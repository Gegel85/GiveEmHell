extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum controlModes {
	MOUSE,
	JOYSTICK
}

var mouseLastPos = Vector2.ZERO
var joyLastDir = Vector2.ZERO

var actualMode = controlModes.MOUSE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		actualMode = controlModes.JOYSTICK
		
func checkForInput():
	var mouseActualPos = get_global_mouse_position()
	if (mouseLastPos != mouseActualPos):
		actualMode = controlModes.MOUSE
	mouseLastPos = mouseActualPos

func Aim():
	checkForInput()
	if (actualMode == controlModes.MOUSE):
		$Direction.look_at(mouseLastPos)
	if (actualMode == controlModes.JOYSTICK):
		var joyDir = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
		if (joyDir.x == 0 && joyDir.y == 0):
			joyDir = joyLastDir
		else:
			joyLastDir = joyDir 
		$Direction.rotation = atan2(joyDir.y, joyDir.x)
	
func SkillActivator():
	var skills
	if ($SkillList.is_inside_tree()):
		 skills = $SkillList.get_children()
	if (skills.count > 0 && Input.is_action_just_pressed("basic_shoot")):
		$SkillList.get_child(0).useSkill()
	if (skills.count > 1 && Input.is_action_just_pressed("skill#1")):
		$SkillList.get_child(1).useSkill()
	if (skills.count > 2 && Input.is_action_just_pressed("skill#2")):
		$SkillList.get_child(2).useSkill()
	if (skills.count > 3 && Input.is_action_just_pressed("skill#3")):
		$SkillList.get_child(3).useSkill()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
