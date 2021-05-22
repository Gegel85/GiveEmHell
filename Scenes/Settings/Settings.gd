extends Node

const SAVE_PATH = "res://config.cfg"

var _config_file = ConfigFile.new()

var settings = {
	"keybind": {
		"controller": false
	}
}

func _ready():
	save_settings()
	load_settings(SAVE_PATH)

func save_settings():
	for section in settings.keys():
		for key in settings[section].keys():
			_config_file.set_value(section, key, settings[section][key])
	_config_file.save(SAVE_PATH)

func load_settings(path):
	var err = _config_file.load(path)

	if err != OK:
		print('Failed to load settings file. Error code %s', err)
		return
	for section in settings.keys():
		for key in settings[section].keys():
			settings[section][key] = _config_file.get_value(section, key, settings[section][key])

func get_setting(category, key):
	return settings[category][key]


func set_setting(category, key, value):
	settings[category][key] = value
