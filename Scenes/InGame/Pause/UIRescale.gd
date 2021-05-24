extends Popup

## onready var players = $VerticalAlign.get_child(0).get_children()

func _ready():
	visible = true

func resize():
	visible = !visible
	visible = !visible
	
func selfFocus(b):
	visible = true
	grab_focus()	
	
func reFocus():
	visible = true
	grab_focus()

func getUI(name):
	return get_node("Grid").get_node(name)
