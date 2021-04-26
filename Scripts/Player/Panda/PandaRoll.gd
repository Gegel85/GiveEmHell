extends Node

var cd = 1000
onready var load_path = "res://Prefabs/Projectile.tscn"

var time_last_used = 0
var actual_time = 0
var use_time = 0
var active_time = 300

var active_skill = false
var speed = 1000
var skill_manager
var player
var world

func _ready():
	world = get_tree().get_root().get_child(0).get_node("Projectiles")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	use_time = actual_time
	time_last_used = actual_time
	active_skill = true

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	if (actual_time - use_time >= active_time):
		active_skill = false
		player.get_node("MovementModule").useForcedSpeed = false
		player.get_node("MovementModule").forcedSpeed = 0
		return
	var nb = player.number - 1
	var bullet = load(load_path).instance()
	world.add_child(bullet)
	bullet.get_node("Appearance").modulate.a = 0
	bullet.duplicate(true)
	bullet.position = player.position	
	bullet.player = player.name
	bullet.lifetime = 50
	bullet.damage = 40
	bullet.size = 2.5
	bullet.speed = 0
	bullet.set_values()
	player.get_node("MovementModule").useForcedSpeed = true
	player.get_node("MovementModule").forcedSpeed = speed
