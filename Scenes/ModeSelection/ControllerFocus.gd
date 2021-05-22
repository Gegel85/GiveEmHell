extends Control

func _ready():
	var btns = get_tree().get_nodes_in_group("Button")
	
	btns[0].grab_focus()
	for btn in btns:
		btn.connect("mouse_entered", self, "force_focus", [btn])
		btn.connect("focus_entered", self, "force_focus", [btn])

func force_focus(btn):
	btn.grab_focus()
