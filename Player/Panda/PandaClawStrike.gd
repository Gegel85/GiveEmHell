extends Node

var cd = 4000
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var casting_time = 2000
var time_last_used = 0
var actual_time = 0
const fire_rate = 200
var use_time = 0
var shoot_time = 0
var active_time = 600
var active_skill = false

var waves_width = 4
var angle_width = 0.8

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
	use_time = actual_time
	shoot_time = 0
	active_skill = true
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)

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
	for i in range(waves_width):
		var bullet = load(load_path).instance()
		getWorld().add_child(bullet)
#		bullet.duplicate(true)
		bullet.move_dir = (skill_manager.angle_aim - float(angle_width) / 2) + (i * (float(angle_width) / (waves_width - 1)))
		bullet.position = player.position
		bullet.player = player.name
		bullet.size = 1.2
		bullet.speed = 500
		bullet.set_values()

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	if (actual_time - use_time >= active_time):
		active_skill = false
		return
	if (actual_time - shoot_time >= fire_rate):
		skill()
		shoot_time = actual_time
