extends Panel

enum Panel {
	IDLE,
	FOCUS
}

var state: int = Panel.IDLE
var characterList = []
var characterIndex: int = 0
onready var container: ReferenceRect = getContainer()
onready var label: Label = getLabel()
onready var texture: TextureRect = getTexture()
onready var rdy: Label = getRdy()
onready var settingsNode = get_node("/root/Settings")
onready var changeChar = getChangeChar()
const CHARACTER_ICON_PATH = "res://Assets/Textures/CharactersIcons/"
var _isOwner = false

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

func getContainer() -> Node:
	return get_child(0).get_child(1)

func getLabel() -> Node:
	return get_child(1)

func getTexture() -> Node:
	if container:
		return container.getTexture()
	else:
		return getContainer().getTexture()

func setIsOwner(isOwner):
		_isOwner = isOwner
		
func changeState() -> void:
	if (state == Panel.IDLE):
		state = Panel.FOCUS
		label.visible = false
		texture.visible = true
		texture.texture = characterList[characterIndex]
		if !settingsNode.get_setting("keybind", "controller") && _isOwner:
			changeChar[0].visible = true
			changeChar[1].visible = true
	else:
		state = Panel.IDLE
		label.visible = true
		texture.visible = false
		changeChar[0].visible = false
		changeChar[1].visible = false


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

func toggleRdy():
	if rdy.visible:
		rdy.visible = false
	else:
		rdy.visible = true
		$AnimationPlayer.play("Ready")

func getRdy() -> Node:
	if container:
		return container.getLabel()
	else:
		return getContainer().getLabel()
	
func getChangeChar():
	return [get_child(0).get_child(0), get_child(0).get_child(2)]


func _on_TriangleButton_left_button_up():
	leftChar()


func _on_TriangleButton_right_button_up():
	rightChar()
