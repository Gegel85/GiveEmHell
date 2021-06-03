extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lifetime
var spawn_time

func _ready():
	spawn_time = OS.get_ticks_msec()

func _process(delta):
	var actual_time = OS.get_ticks_msec()
	if (actual_time - spawn_time >= lifetime):
		queue_free()
