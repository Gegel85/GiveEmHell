extends Node2D

var cd = 5000
const fire_rate = 500
var sounds
export var soundeffect: AudioStream
export var bounce_soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/ShockWave.tscn"

var casting_time = 2000
var time_last_used = 0
var use_time = 0
var shoot_time = 0
var actual_time = 0
var active_time = 500
var active_skill = false

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

func _process(delta):
	actual_time = OS.get_ticks_msec()
	
	if (!active_skill):
		return
	if (actual_time - use_time >= active_time):
		active_skill = false
		return
	if (actual_time - shoot_time >= fire_rate):
		skill()
		shoot_time = actual_time

func onHit(object, bullet):
	if (object.is_in_group("Player")):
		if (object.get_name() != bullet.player):
			var sound = load(sound_path).instance()
			getSound().add_child(sound)
			sound.init_player(bounce_soundeffect)
			var direction = object.position - bullet.position
			object.move_and_slide(object.position + (direction * 75))

func skill():
	var bullet = load(load_path).instance()
	getWorld().add_child(bullet)
	bullet.get_node("Appearance").modulate.a = 10
	bullet.stay = true
#	bullet.duplicate(true)
	bullet.position = player.position	
	bullet.player = player.name
	bullet.lifetime = 500
	bullet.size_min = 2
	bullet.size_max = 20
	bullet.speed = 0
	bullet.set_values()
	bullet.get_node("Collider").connect("body_entered", self, "onHit", [bullet])
