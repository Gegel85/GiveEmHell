extends Node

const cd = 8000
const fire_rate = 100
var use_time = 0
var shoot_time = 0
var active_time = 3500
var alternate_speed = 750
var last_alternate = 0
var active_skill = false
var pos_spawn = Vector2.ZERO

onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var time_last_used = 0
var actual_time = 0
onready var rotater = $Rotater

var base_rotate_speed = 50
var rotate_speed = 0
var rotate_dir = 0
const spawn_point_count = 6
const radius = 500

var skill_manager
var player
var world

func _ready():
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

func skill():
	for s in rotater.get_children():
		var bullet = load(load_path).instance()
		getWorld().add_child(bullet)
#		bullet.duplicate(true)
		bullet.position = player.position
		bullet.distance_max = radius
		bullet.player = player.name
		bullet.size = 0.75
		bullet.speed = base_rotate_speed * 3
		bullet.set_values()
		bullet.move_dir = s.global_rotation	

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	## rotate_speed = base_rotate_speed + ((((rotate_max - base_rotate_speed) * (actual_time - time_last_used)) / float(active_time)))
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	if (actual_time - use_time >= active_time):
		active_skill = false
		return
	## max_fire_rate + fire_rate - (fire_rate * (rotate_speed / rotate_max * 2))
	if (actual_time - shoot_time >= fire_rate):
		skill()
		shoot_time = actual_time

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		if (actual_time - last_alternate >= alternate_speed):
			last_alternate = actual_time
			rotate_speed *= -1
		return
	last_alternate = actual_time
	time_last_used = actual_time
	rotate_speed = base_rotate_speed
	rotate_dir = 1
	use_time = actual_time
	shoot_time = 0
	active_skill = true
	pos_spawn = player.position
