extends Node

const cd = 5000
const fire_rate = 300
var use_time = 0
var shoot_time = 0
var active_time = 2100
var active_skill = false
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var bullet_path = "res://Prefabs/Characters/Projectile.tscn"

var casting_time = 4000
export var time_last_used = 0
export var actual_time = 0
onready var rotater = $Rotater

const rotate_speed = 120
const base_rotation = 0
const spawn_point_count = 8
const radius = 100

var spawn_pos

var skill_manager
var player
var projectiles

func _ready():
	sounds = get_tree().get_root().get_node("MainScene").get_node("Sounds")
	projectiles = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
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
	if projectiles:
		return projectiles
	projectiles = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	return projectiles

func getSound():
	if sounds:
		return sounds
	sounds = get_tree().get_root().get_node("MainScene").get_node("Sounds")
	return sounds


func skill():
	for s in rotater.get_children():
		var bullet = load(bullet_path).instance()
		getWorld().add_child(bullet)
#		bullet.duplicate(true)
		bullet.position = spawn_pos
		bullet.player = player.name
		bullet.size = 0.75
		bullet.speed = 100
		bullet.set_values()
		bullet.move_dir = s.global_rotation

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	if (actual_time - use_time >= active_time):
		active_skill = false
		return
	if (actual_time - shoot_time >= fire_rate):
		skill()
		shoot_time = actual_time

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	player.make_casting_for(casting_time, true)
	time_last_used = actual_time
	use_time = actual_time
	shoot_time = 0
	active_skill = true
	spawn_pos = player.position
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
