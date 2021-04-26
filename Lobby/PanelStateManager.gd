extends Panel

enum Panel {
	IDLE,
	FOCUS
}

var state = Panel.IDLE
var characterList = []
var characterIndex = 0

func _init():
	var dir = Directory.new()

	dir.open("res://Textures/CharactersIcons/")
	dir.list_dir_begin(true, true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		if !file.ends_with(".import"):
			characterList.append("res://Textures/CharactersIcons/" + file)
	dir.list_dir_end()
	print(characterList)
	for i in range(0, characterList.size()):
		characterList[i] = load(characterList[i])

func getLabel():
	return get_child(0)

func getTexture():
	return get_child(1)

func changeState():
	if (state == Panel.IDLE):
		state = Panel.FOCUS
		getLabel().visible = false
		getTexture().visible = true
		getTexture().texture = characterList[characterIndex]
	else:
		state = Panel.IDLE
		getLabel().visible = true
		getTexture().visible = false

func rightChar():
	if characterIndex == (characterList.size() - 1):
		characterIndex = 0
	else:
		characterIndex += 1
	getTexture().texture = characterList[characterIndex]

func leftChar():
	if characterIndex == 0:
		characterIndex = (characterList.size() - 1)
	else:
		characterIndex -= 1
	getTexture().texture = characterList[characterIndex]
	
