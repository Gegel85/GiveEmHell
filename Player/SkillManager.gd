extends Node2D

var player
var mouseLastPos = Vector2.ZERO
var joyLastDir = Vector2.ZERO
var deadZone = 0.1
export var angle_aim = 0

func _ready():
	player = get_parent()

func Aim():
	var nb = player.device.id
	if (player.device.type == Device.DeviceType.MOUSE_KEYBOARD):
		mouseLastPos = get_global_mouse_position()
		$Direction.look_at(mouseLastPos)
		angle_aim = get_angle_to(mouseLastPos)
	else:
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
	
func SkillActivator():
	var nb = player.device.id + 1
	if (player.device.type == Device.DeviceType.MOUSE_KEYBOARD):
		nb = "KB"
	var skills
	if ($SkillList.is_inside_tree()):
		 skills = $SkillList.get_children()
	var nb_skills = skills.size()
	if (nb_skills > 0 && Input.is_action_pressed("basic_shoot_" + str(nb))):
		$SkillList.get_child(0).useSkill()
	if (nb_skills > 1 && Input.is_action_pressed("skill1_" + str(nb))):
		$SkillList.get_child(1).useSkill()
	if (nb_skills > 2 && Input.is_action_pressed("skill2_" + str(nb))):
		$SkillList.get_child(2).useSkill()
	if (nb_skills > 3 && Input.is_action_pressed("skill3_" + str(nb))):
		$SkillList.get_child(3).useSkill()
