extends GridContainer

var lives = []
var skills = []
var icons = []
var pos_max = 24
const skill_order = [3, 0, 2, 1]
var dir

func _ready():
	var children = get_children()
	for i in range(children.size()):
		if (i < 4):
			lives.append(children[i])
		else:
			skills.append(children[i])

func setIconImages(character):
	var icons_path = "res://Assets/Textures/CharactersAttackIcons/" + character + "/"
	var dir = Directory.new()
	dir.open(icons_path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			#get_next() returns a string so this can be used to load the images into an array.
			icons.append(load(icons_path + file_name))
	dir.list_dir_end()
	for i in range(skills.size()):
		skills[skill_order[i]].get_child(0).texture = icons[i]

func init(player):
	self.visible = true
	for i in range(lives.size()):
		lives[i].get_child(0).get_child(0).self_modulate = player.color
	for i in range(skills.size()):
		skills[i].get_child(0).self_modulate = player.color
	setIconImages(player.character)

func setLife(nb):
	for i in range(lives.size()):
		if (i < nb):
			lives[i].get_child(0).get_child(0).visible = true
		else:
			lives[i].get_child(0).get_child(0).visible = false

func setCooldownSkill(maxLength, actual, nb):
	if (nb >= skills.size()):
		return
	var cooldown = skills[skill_order[nb]].get_child(0).get_child(0)
	var percent = float(actual) / maxLength
	cooldown.scale.y = 1 - percent
	cooldown.position.y = pos_max - pos_max * (1 - percent)
