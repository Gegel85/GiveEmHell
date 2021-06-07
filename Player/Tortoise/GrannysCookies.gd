extends Node

onready var rotater = $Rotater
var player
const rotate_speed = 0
const base_rotation = 0
const spawn_point_count = 8
const radius = 10
var load_path
var skill

func _ready():
	skill = get_parent()
	player = skill.player
	load_path = skill.load_path
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
		skill.getWorld().add_child(bullet)
#		bullet.duplicate(true)
		bullet.position = player.position
		bullet.player = player.name
		bullet.size = 0.75
		bullet.speed = 200
		bullet.set_values()
		bullet.move_dir = s.global_rotation	

func _process(delta):
	if (!skill.active_skill):
		return
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	if (skill.actual_time - skill.shoot_time >= skill.fire_rate):
		skill()
		skill.shoot_time = skill.actual_time
