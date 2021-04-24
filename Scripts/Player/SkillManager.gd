extends Node2D

enum controlModes {
	MOUSE,
	JOYSTICK
}

var mouseLastPos = Vector2.ZERO
var joyLastDir = Vector2.ZERO
var deadZone = 0.2
var actualMode = controlModes.JOYSTICK
export var angle_aim = 0

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

func Aim(nb):
	"""checkForInput()"""
	if (actualMode == controlModes.MOUSE):
		$Direction.look_at(mouseLastPos)
	if (actualMode == controlModes.JOYSTICK):
		var joyDir = Vector2(Input.get_joy_axis(nb, 2), Input.get_joy_axis(nb, 3))
		if (abs(joyDir.x) < deadZone):
			joyDir.x = 0
		if (abs(joyDir.y) < deadZone):
			joyDir.y = 0
		if (joyDir.x == 0 && joyDir.y == 0):
			joyDir = joyLastDir
		else:
			joyLastDir = joyDir 
		angle_aim = atan2(joyDir.y, joyDir.x)
		$Direction.rotation = angle_aim
	
func SkillActivator(nb):
	var skills
	if ($SkillList.is_inside_tree()):
		 skills = $SkillList.get_children()
	var nb_skills = skills.size()
	if (nb_skills > 0 && Input.is_joy_button_pressed(nb, JOY_R2)):
		$SkillList.get_child(0).useSkill()
	if (nb_skills > 1 && Input.is_joy_button_pressed(nb, JOY_R)):
		$SkillList.get_child(1).useSkill()
	if (nb_skills > 2 && Input.is_joy_button_pressed(nb, JOY_L)):
		$SkillList.get_child(2).useSkill()
	if (nb_skills > 3 && Input.is_joy_button_pressed(nb, JOY_L2)):
		$SkillList.get_child(3).useSkill()
