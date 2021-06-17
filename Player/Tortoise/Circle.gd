extends Node

const cd = 3000
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var casting_time = 2000
var time_last_used = 0
var actual_time = 0
onready var indicator = $MainIndicator

const rotate_speed = 80
const base_rotation = 0
const spawn_point_count = 4
const radius = 100
const size_min = 25
const size_max = 175

var skill_manager
var player
var world
var using = false
var pressed = false
var sized = size_min

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

func skill():
	var maximum = 8 + sized / 4

	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	for i in range(maximum):
		var angle = 2 * PI * i / maximum
		var bullet = load(load_path).instance()

		getWorld().add_child(bullet)
		bullet.position = player.position + 160 * (sized * 0.01) * Vector2(cos(angle), sin(angle))
		bullet.player = player.name
		bullet.size = 0.75
		bullet.speed = max(200, sized)
		bullet.set_values()
		bullet.move_dir = angle

func _process(delta):
	if using and not pressed:
		indicator.modulate.a = 0
		using = false
		skill()
		sized = size_min
		time_last_used = actual_time
		player.make_casting_for(casting_time, true)
	if using:
		player.make_casting_for(0, true)
		if (sized < size_max):
			sized += 1
		else:
			sized = size_max
		indicator.position = player.position
		indicator.scale = Vector2(sized * 0.01, sized * 0.01)
		indicator.modulate = player.color
		indicator.modulate.a = 1
	pressed = false

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	using = true
	pressed = true
