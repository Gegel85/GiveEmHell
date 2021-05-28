extends Node

var cd = 200
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var time_last_used = 0
var actual_time = 0
var shoot_time = 0
var fire_rate = 150
const aim_radius = 35

var using = false
var pressed = false
var bullet_spawn = 0
var bullet_rotation = 1
var time_since_ramp = 0
var ramp_up_time = 1200

const bullets_angles = [0.3, -0.3, 1, -1]
const max_bullet_swap = 4

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
	using = true
	pressed = true

func getWorld():
	if world:
		return world
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	return world

func _process(delta):
	if using and not pressed:
		using = false
		bullet_spawn = 0
		bullet_rotation = 1
		time_since_ramp = 0
		time_last_used = actual_time
	if using:
		actual_time = OS.get_ticks_msec()
		if (actual_time - time_since_ramp > ramp_up_time && bullet_spawn < max_bullet_swap):
			time_since_ramp = actual_time
			bullet_spawn += 1
			print("ramping up")
		if (actual_time - shoot_time >= fire_rate):
			shoot_time = actual_time
			skill()
	pressed = false

func skill():
	if (bullet_rotation > bullet_spawn):
		bullet_rotation = (bullet_rotation % 4) + 1
		return
	var bullet = load(load_path).instance()
	getWorld().add_child(bullet)
	bullet.move_dir = skill_manager.angle_aim
	bullet.position.x = player.position.x + cos(skill_manager.angle_aim + bullets_angles[bullet_rotation - 1]) * aim_radius
	bullet.position.y = player.position.y + sin(skill_manager.angle_aim + bullets_angles[bullet_rotation - 1]) * aim_radius
	bullet.player = player.name
	bullet.size = 0.75
	bullet.set_values()
	bullet_rotation = (bullet_rotation % 4) + 1
