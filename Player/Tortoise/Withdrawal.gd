extends Node2D

var cd = 5000

var time_last_used = 0
var actual_time = 0
var use_time = 0
var active_time = 1500

var active_skill = false
var skill_manager
var player
var world
var shield_sprite
var collision_shield
var color_b = Vector2(150, 255)
var opacity = Vector2(30, 95)

func _ready():
	shield_sprite = get_node("Sprite")
	collision_shield = get_node("Collider").get_node("CollisionShape2D")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()
	get_node("Collider").connect("area_entered", self, "bounce_balls")
	get_node("Collider").get_child(0).name = player.name

func bounce_balls(object):
	var player_name = get_node("Collider").get_child(0).name
	var obj_parent = object.get_parent()
	if (object.is_in_group("Bullet")):
		if (obj_parent.player != player_name):
			obj_parent.player = player_name
			obj_parent.move_dir += PI
			obj_parent.color = player.color
			obj_parent.set_color_to_player()
			obj_parent.spawn_pos = obj_parent.position

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	use_time = actual_time
	time_last_used = actual_time
	active_skill = true

func _process(delta):
	position = player.position
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	if (actual_time - use_time >= active_time):
		active_skill = false
		collision_shield.set_disabled(true)
		shield_sprite.modulate.a = 0
		player.get_node("MovementModule").useForcedSpeed = false
		return
	var moveModule = player.get_node("MovementModule")
	player.get_node("MovementModule").useForcedSpeed = true
	player.get_node("MovementModule").forcedSpeed = moveModule.speed / 2
	collision_shield.set_disabled(false)
	shield_sprite.modulate.a = 0.8
	
