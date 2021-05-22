extends OptionButton

var keybindItems = ['Controller', ' Mouse + Keyboard']
onready var settingsNode = get_node("/root/Settings")

func _ready():
	for item in keybindItems:
		.add_item(item)
	if !settingsNode.settings["keybind"]["controller"]:
		.select(1)

func _on_OptionButton_item_selected(index):
	if .get_index() == index:
		return
	if index == 1:
		settingsNode.set_setting("keybind", "controller", false)
	else:
		settingsNode.set_setting("keybind", "controller", true)
	settingsNode.save_settings()
