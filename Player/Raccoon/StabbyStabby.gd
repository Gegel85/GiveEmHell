extends Node

var cd = 400
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var time_last_used = 0
var actual_time = 0

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
	time_last_used = actual_time
	skill()

func getWorld():
	if world:
		return world
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	return world

func callback(object):
	if (object.is_in_group("Bullet")):
		var p = object.get_parent().queue_free()

func skill():
	var bullet = load(load_path).instance()
	getWorld().add_child(bullet)
#	bullet.duplicate(true)
	bullet.move_dir = skill_manager.angle_aim
	bullet.position = player.position
	bullet.player = player.name
	bullet.size = 2
	bullet.distance_max = 100
	bullet.speed = 500
	bullet.callback = funcref(self, "callback")
	bullet.set_values()
