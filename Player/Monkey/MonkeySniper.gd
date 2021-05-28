extends Node

var cd = 1200
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
export var soundeffect: AudioStream

var time_last_used = 0
var actual_time = 0

var skill_manager
var player
var world
var sounds

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
	var bullet = load(load_path).instance()
	getWorld().add_child(bullet)	
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	bullet.duplicate(true)
	bullet.move_dir = skill_manager.angle_aim
	bullet.speed = 1000
	bullet.distance_max = 2000
	bullet.position = player.position
	bullet.player = player.name
	bullet.size = 1.5
	bullet.set_values()
	sound.init_player(soundeffect)
