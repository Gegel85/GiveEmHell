extends Popup

onready var firstChild = $VerticalAlign.get_child(0)
onready var lastFocus = firstChild

func _input(event):
	if Input.is_action_just_released("pause"):
		get_tree().paused = !get_tree().paused
		visible = !visible
		if visible == true:
			firstChild.grab_focus()
		


func _ready():
	var btns = $VerticalAlign.get_children()
	
	for b in btns:
		b.connect("mouse_entered", self, "selfFocus", [b])
		b.connect("focus_entered", self, "selfFocus", [b])
	
func selfFocus(b):
	lastFocus = b
	lastFocus.grab_focus()
	
func reFocus():
	lastFocus.grab_focus()
