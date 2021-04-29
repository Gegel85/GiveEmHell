extends Button

var panelContainer

func _ready():

	if !OS.is_debug_build():
		modulate = Color(0, 0, 0, 0)
		disabled = true
	else:
		var root = get_tree().get_root()
		
		panelContainer = root.get_node("MainScreen/PanelContainer")

# warning-ignore:unused_argument
func _process(delta):
	if !panelContainer.isRdy():
		disabled = true
	else:
		disabled = false

func _on_button_up():
	panelContainer.start()
