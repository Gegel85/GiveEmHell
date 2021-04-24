extends Node

var cd = 1200
onready var projectile_obj = preload("res://Prefabs/Panda/Projectile.tscn")

var time_last_used = 0
var actual_time = 0

var skill_manager
var player
var world

func _ready():
	world = get_tree().get_root().get_child(0).get_node("Projectiles")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd):
		return
	time_last_used = actual_time
	skill()

func skill():
	var bullet = projectile_obj.instance()
	world.add_child(bullet)
	bullet.direction = skill_manager.angle_aim
	bullet.speed = 2000
	bullet.distance_max = 2000
	bullet.spawn_pos = player.position
	bullet.position = player.position
