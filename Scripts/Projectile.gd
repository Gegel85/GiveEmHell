extends KinematicBody2D

var player = ""
var move_dir = float()
var spawn_pos = Vector2.ZERO
var speed = 300
var distance_max = 400
var damage = 20
var lifetime = 99999 
var size = 1
var spawn_time = 0
var vector

func _ready():
	set_values()

func set_values():
	spawn_pos = position
	$Appearance.scale = Vector2(size, size)
	$Collider.get_node("CollisionShape2D").scale = Vector2(size * 2, size * 2)
	$Collider.connect("area_entered", self, "on_collision")
	spawn_time = OS.get_ticks_msec()

func on_collision(object):
	var obj_parent = object.get_parent()
	if (object.is_in_group("Player")):
		if (obj_parent.name != player):
			obj_parent.take_damage(damage)
			queue_free()

func _process(delta):
	var actual_time = OS.get_ticks_msec()	
	vector = Vector2(cos(move_dir), sin(move_dir))
	move_and_slide(vector  * speed)
	if (spawn_pos.distance_to(position) > distance_max):
		queue_free()
	if (actual_time - spawn_time >= lifetime):
		queue_free()
