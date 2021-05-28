extends Control

func _ready():
	var btns = get_tree().get_nodes_in_group("Button")
	
	btns[0].grab_focus()
	for btn in btns:
		btn.connect("mouse_entered", self, "force_focus", [btn])
		btn.connect("focus_entered", self, "force_focus", [btn])
		btn.connect("button_down", self, "validate")

func force_focus(btn):
	btn.grab_focus()	
	get_tree().get_root().get_node("Sfx/Button/Select").play()

func validate():
	get_tree().get_root().get_node("Sfx/Button/Validate").play()
