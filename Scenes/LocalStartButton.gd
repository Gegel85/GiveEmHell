extends Button

class_name InputManager

var panelContainer: InputManager

func _ready() -> void:
	if !OS.is_debug_build():
		modulate = Color(0, 0, 0, 0)
		disabled = true
	else:
		var root = get_tree().get_root()
		
		panelContainer = root.get_node("MainScreen/PanelContainer")

# warning-ignore:unused_argument
func _process(delta) -> void:
	if !panelContainer.isRdy():
		disabled = true
	else:
		disabled = false

func _on_button_up() -> void:
	panelContainer.start()
