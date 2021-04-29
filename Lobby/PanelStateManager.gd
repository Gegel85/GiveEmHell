extends Panel

enum Panel {
	IDLE,
	FOCUS
}

var state: Panel = Panel.IDLE
var characterList = []
var characterIndex: int = 0
var label: Label
var texture: TextureRect
const CHARACTER_ICON_PATH = "res://Textures/CharactersIcons/"

func _init() -> void:
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

func _ready() -> void:
	label = getLabel()
	texture = getTexture()

func getLabel() -> Node:
	return get_child(0)

func getTexture() -> Node:
	return get_child(1)

func changeState() -> void:
	if (state == Panel.IDLE):
		state = Panel.FOCUS
		label.visible = false
		texture.visible = true
		texture.texture = characterList[characterIndex]
	else:
		state = Panel.IDLE
		label.visible = true
		texture.visible = false

func getChar() -> String:
	var name = characterList[characterIndex].get_load_path().split(".png")[0]

	name = name.split("/")
	name = name[name.size() - 1]
	return name

func rightChar() -> void:
	if characterIndex == (characterList.size() - 1):
		characterIndex = 0
	else:
		characterIndex += 1
	texture.texture = characterList[characterIndex]

func leftChar() -> void:
	if characterIndex == 0:
		characterIndex = (characterList.size() - 1)
	else:
		characterIndex -= 1
	texture.texture = characterList[characterIndex]
	
func setColorTexture(color) -> void:
	getTexture().modulate = color
