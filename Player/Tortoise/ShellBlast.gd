extends Node

const cd = 1000
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var casting_time = 2000
var time_last_used = 0
var actual_time = 0
onready var rotater = $Rotater

const rotate_speed = 80
const base_rotation = 0
const spawn_point_count = 4
const radius = 100

var skill_manager
var player
var world

func _ready():
	sounds = get_tree().get_root().get_node("MainScene").get_node("Sounds")
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()
	var step = 2 * PI / spawn_point_count
	
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

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
	for s in rotater.get_children():
		var bullet = load(load_path).instance()
		getWorld().add_child(bullet)
#		bullet.duplicate(true)
		bullet.position = player.position
		bullet.player = player.name
		bullet.size = 1
		bullet.speed = 300
		bullet.set_values()
		bullet.move_dir = s.global_rotation

func _process(delta):
	actual_time = OS.get_ticks_msec()
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	player.make_casting_for(casting_time, true)
	time_last_used = actual_time
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	skill()
