extends Button

class_name InputManager

var panelContainer

func _ready() -> void:
	if !OS.is_debug_build():
		modulate = Color(0, 0, 0, 0)
		disabled = true

func getPanelContainer():
	var root = get_tree().get_root()
	
	if panelContainer:
		return panelContainer
	panelContainer = root.get_node("MainScreen/PanelContainer")
	return panelContainer

# warning-ignore:unused_argument
func _process(delta) -> void:
	if !getPanelContainer().isRdy():
		disabled = true
	else:
		disabled = false

func _on_button_up() -> void:
	getPanelContainer().start()
