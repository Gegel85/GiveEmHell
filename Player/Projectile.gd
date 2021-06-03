extends KinematicBody2D

var player = ""

var move_dir = 0
var spawn_pos = Vector2.ZERO
var speed = 0
var acceleration = 0
var speed_min_cap = 0
var speed_max_cap = 999999

var distance_max = 0
var lifetime = 99999
var size = 1
var spawn_time = 0
var vector
var color = Color(255, 255, 255)
var callback = null
var invincible = false
var stay = false

func _ready():
	$Collider.connect("area_entered", self, "on_area_collision")
	$Collider.connect("body_entered", self, "on_body_collision")
	set_values()

func set_color_to_player():
	color = get_tree().get_root().get_node("MainScene/Players").get_node(player).color
	$Appearance.modulate = color

func set_values():
	spawn_pos = position
	$Appearance.scale = Vector2(size, size)
	$Collider.get_node("CollisionShape2D").scale = Vector2(size * 2, size * 2)
	
	spawn_time = OS.get_ticks_msec()
	if (player != ""):
		set_color_to_player()

func on_area_collision(object):
	if (stay):
		return
	var obj_parent = object.get_parent()
	
	if callback != null:
		if (obj_parent.name != player):
			callback.call_func(object)	
	if (object.is_in_group("Player")):
		if (obj_parent.name != player):
			obj_parent.take_damage(1)
			queue_free()

func on_body_collision(object):
	if (invincible):
		return
	if (object.is_in_group("Wall")):
		queue_free()

func _process(delta):
	var actual_time = OS.get_ticks_msec()
	vector = Vector2(cos(move_dir), sin(move_dir))
	move_and_slide(vector  * speed)
	speed = max(speed_min_cap, min(speed_max_cap, speed + acceleration))
	if (spawn_pos.distance_to(position) > distance_max && distance_max > 0):
		queue_free()
	if (actual_time - spawn_time >= lifetime):
		queue_free()
