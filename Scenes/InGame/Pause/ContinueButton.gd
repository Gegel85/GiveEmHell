extends Button

func _on_button_up():
	get_tree().paused = !get_tree().paused
	getPopup().visible = !getPopup().visible

func getPopup():
	return get_parent().get_parent()
