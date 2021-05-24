extends VBoxContainer

onready var lastFocus = $PlayButton
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"

func _ready():
	$PlayButton.grab_focus()
# warning-ignore:return_value_discarded
	$PlayButton.connect("mouse_entered", self, "focusPlay")
# warning-ignore:return_value_discarded
	$PlayButton.connect("focus_entered", self, "focusPlay")
# warning-ignore:return_value_discarded
	$QuitButton.connect("mouse_entered", self, "focusQuit")
# warning-ignore:return_value_discarded
	$QuitButton.connect("focus_entered", self, "focusQuit")
	
func focusPlay():
	lastFocus = $PlayButton
	lastFocus.grab_focus()
	var sound = load(sound_path).instance()
	sound.init_player(soundeffect)
	
func focusQuit():
	lastFocus = $QuitButton
	lastFocus.grab_focus()


