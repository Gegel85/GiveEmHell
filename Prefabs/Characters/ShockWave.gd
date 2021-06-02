extends KinematicBody2D

var player = ""

var move_dir = 0
var spawn_pos = Vector2.ZERO
var speed = 300
var acceleration = 0
var speed_min_cap = 0
var speed_max_cap = 999999

var size_min = 0.5
var size_max = 2
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
	set_values()

func set_color_to_player():
	color = get_tree().get_root().get_node("MainScene/Players").get_node(player).color
	$Appearance.modulate = color

func set_scales():
	scale = Vector2(size, size)

func set_values():
	spawn_pos = position
	size = size_min
	set_scales()
	spawn_time = OS.get_ticks_msec()
	if (player != ""):
		set_color_to_player()

func _process(delta):
	var actual_time = OS.get_ticks_msec()
	vector = Vector2(cos(move_dir), sin(move_dir))
	move_and_slide(vector  * speed)
	size = size_min + (actual_time - spawn_time)  * (size_max - size_min) / lifetime
	set_scales()
	speed = max(speed_min_cap, min(speed_max_cap, speed + acceleration))
	if (spawn_pos.distance_to(position) > distance_max && distance_max > 0):
		queue_free()
	if (actual_time - spawn_time >= lifetime):
		queue_free()
