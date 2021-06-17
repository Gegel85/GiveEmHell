extends Node

var cd = 8000
var sounds
export var soundeffect: AudioStream
export var roar_soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"

var casting_time = 2000
var time_last_used = 0
var actual_time = 0
var use_time = 0
var active_time = 500

var active_skill = false
var speed = 1000
var skill_manager
var player
var world

func _ready():
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	player.make_casting_for(casting_time, true)
	use_time = actual_time
	time_last_used = actual_time
	active_skill = true
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(roar_soundeffect)
	player.make_invincible_for(active_time)

func getWorld():
	if world:
		return world
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	return world

func getSound():
	if sounds:
		return sounds
	sounds = get_tree().get_root().get_node("MainScene").get_node("Sounds")
	return sounds

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	if (actual_time - use_time >= active_time):
		active_skill = false
		player.get_node("MovementModule").useForcedSpeed = false
		player.get_node("MovementModule").forcedSpeed = 0
		return
	player.get_node("MovementModule").useForcedSpeed = true
	player.get_node("MovementModule").forcedSpeed = speed
