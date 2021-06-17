extends Node

var cd = 500
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var casting_time = 2000
var time_last_used = 0
var actual_time = 0

var shot_angle = 0.25

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
	for i in range(3):
		var bullet = load(load_path).instance()
		getWorld().add_child(bullet)
#		bullet.duplicate(true)
		bullet.move_dir = skill_manager.angle_aim - float(shot_angle) + (i * shot_angle)
		bullet.position = player.position
		bullet.player = player.name
		bullet.speed = 300
		bullet.size = 1
		bullet.set_values()
