extends Node

var cd = 5000
const fire_rate = 500
var sounds
export var soundeffect: AudioStream
export var bounce_soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Area.tscn"

var casting_time = 2000
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
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	player.make_casting_for(casting_time, true)
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
	var players = getWorld().get_parent().get_node("Players").get_children()
	for pl in players:
		if (pl.name != player.name):
			var bullet = load(load_path).instance()
			var projectiles = bullet.get_children()
			for proj in projectiles:
				if (proj.is_in_group("Bullet")):
					proj.player = player.name
					proj.get_node("Appearance").modulate = player.color
			getWorld().add_child(bullet)
		#	bullet.duplicate(true)
			bullet.position = pl.position
			bullet.player = player.name
			bullet.speed = 0
