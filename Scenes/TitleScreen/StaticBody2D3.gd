extends StaticBody2D

func _ready():
	get_tree().get_root().connect("size_changed", self, "resize")
	
func resize():
	position = Vector2(get_viewport().size.x / 2, get_viewport().size.y)
