extends Button

func _on_button_up():
	get_tree().paused = false
	var level = loadScene("res://Scenes/TitleScreen/TitleScreen.tscn")
	get_tree().set_current_scene(level)
	get_tree().get_root().get_node("TitleScreenMusic").play()	
	unloadScene("MainScene")

func loadScene(path: String):
	var root = get_tree().get_root()
	var next_level = load(path).instance()

	root.add_child(next_level)
	return next_level

func unloadScene(node: String) -> void:
	var root = get_tree().get_root()
	var level = root.get_node(node)

	root.remove_child(level)
	level.call_deferred("free")
