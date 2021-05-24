extends GridContainer

var lives = []
var skills = []
var pos_max = 0
var pos_min = 24

var dir


func _ready():
	var children = get_children()
	for i in range(children.size()):
		if (i < 4):
			lives.append(children[i])
		else:
			skills.append(children[i])

func init(player):
	self.visible = true
	for i in range(lives.size()):
		lives[i].get_child(0).get_child(0).self_modulate = player.color
	for i in range(skills.size()):
		skills[i].get_child(0).self_modulate = player.color

func setLife(nb):
	for i in range(lives.size()):
		if (i < nb):
			lives[i].get_child(0).visible = true
		else:
			lives[i].get_child(0).visible = false

func setCooldownSkill(maxLength, actual, nb):
	if (nb >= skills.size()):
		return
	var cooldown = skills[nb].get_child(0).get_child(0)
	var percent = float(actual) / maxLength
	cooldown.scale.y = maxLength * percent
	cooldown.position.y = pos_min + ((pos_max + (pos_min * -1)) * percent)
