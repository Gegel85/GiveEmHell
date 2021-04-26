extends Node

var cd = 200
onready var load_path = "res://Prefabs/Panda/Projectile.tscn"

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
	var bullet = load(load_path).instance()
	world.add_child(bullet)
	bullet.duplicate(true)
	bullet.move_dir = skill_manager.angle_aim
	bullet.position = player.position
	bullet.player = player.name
	bullet.size = 0.75
	bullet.set_values()
