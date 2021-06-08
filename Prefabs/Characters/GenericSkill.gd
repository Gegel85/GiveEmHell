extends Node

const cd = 5000
const fire_rate = 300
var use_time = 0
var shoot_time = 0
var active_time = 1200
var active_skill = false
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

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	time_last_used = actual_time
	use_time = actual_time
	shoot_time = 0
	active_skill = true
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	if (actual_time - use_time >= active_time):
		active_skill = false
		return
