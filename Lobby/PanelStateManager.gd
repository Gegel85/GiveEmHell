extends Panel

enum Panel {
	IDLE,
	FOCUS
}

var state = Panel.IDLE
var characterList = []
var characterIndex = 0
var label: Label
var texture: TextureRect
const CHARACTER_ICON_PATH = "res://Textures/CharactersIcons/"

func _init():
	var dir = Directory.new()

	dir.open(CHARACTER_ICON_PATH)
	dir.list_dir_begin(true, true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".import"):
			characterList.append(CHARACTER_ICON_PATH + file.replace(".import", ""))
	dir.list_dir_end()
	for i in range(characterList.size()):
		characterList[i] = load(characterList[i])

func _ready():
	label = getLabel()
	texture = getTexture()

func getLabel():
	return get_child(0)

func getTexture():
	return get_child(1)

func changeState():
	if (state == Panel.IDLE):
		state = Panel.FOCUS
		label.visible = false
		texture.visible = true
		texture.texture = characterList[characterIndex]
	else:
		state = Panel.IDLE
		label.visible = true
		texture.visible = false

func getChar():
	var name = characterList[characterIndex].get_load_path().split(".png")[0]

	name = name.split("/")
	name = name[name.size() - 1]
	return name

func rightChar():
	if characterIndex == (characterList.size() - 1):
		characterIndex = 0
	else:
		characterIndex += 1
	texture.texture = characterList[characterIndex]

func leftChar():
	if characterIndex == 0:
		characterIndex = (characterList.size() - 1)
	else:
		characterIndex -= 1
	texture.texture = characterList[characterIndex]
	
func setColorTexture(color):
	getTexture().modulate = color
