tool
extends Button

export(String, FILE) var next_scene_path = ""

func _onButtonUp():
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next scene path must be set for the button to work" if next_scene_path == "" else ""
