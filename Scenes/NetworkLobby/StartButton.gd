extends Button

var panelContainer

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
