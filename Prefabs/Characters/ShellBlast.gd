extends Node

const cd = 400

onready var load_path = "res://Prefabs/Projectile.tscn"

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
	world = get_tree().get_root().get_child(0).get_node("Projectiles")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

func skill():
	for s in rotater.get_children():
		var bullet = load(load_path).instance()
		world.add_child(bullet)
		bullet.duplicate(true)
		bullet.position = player.position
		bullet.player = player.name
		bullet.size = 0.75
		bullet.speed = 100
		bullet.set_values()
		bullet.move_dir = s.global_rotation

func _process(delta):
	actual_time = OS.get_ticks_msec()
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd):
		return
	time_last_used = actual_time
	skill()
