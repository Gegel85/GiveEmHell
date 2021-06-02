extends Node

var cd = 200
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var time_last_used = 0
var actual_time = 0

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
	time_last_used = actual_time
	skill()

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

func skill():
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	var bullet = load(load_path).instance()
	getWorld().add_child(bullet)
#	bullet.duplicate(true)
	bullet.move_dir = skill_manager.angle_aim
	bullet.position = player.position
	bullet.player = player.name
	bullet.size = 0.75
	bullet.set_values()
