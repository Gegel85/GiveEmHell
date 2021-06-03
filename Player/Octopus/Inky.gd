extends Node2D

var cd = 5000
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var ink_path = "res://Prefabs/Ink.tscn"
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
var color_black = Color(0, 0, 0)
var color_b = Vector2(150, 255)
var opacity = Vector2(30, 95)
var ink_proj

func _ready():
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()

func getWorld():
	if world:
		return world
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	return world

func getSound():
	if sounds:
		return sounds
	sounds = get_tree().get_root().get_node("MainScene").get_node("Sounds")
	return sounds

func get_vals():
	ink_proj.lifetime = 2500
	shield_sprite = ink_proj.get_node("Sprite")
	collision_shield = ink_proj.get_node("Collider").get_node("CollisionShape2D")
	ink_proj.get_node("Collider").connect("area_entered", self, "bounce_balls")
	ink_proj.get_node("Collider").get_child(0).name = player.name

func bounce_balls(object):
	var player_name = get_node("Collider").get_child(0).name
	var obj_parent = object.get_parent()
	if (object.is_in_group("Bullet")):
		if (obj_parent.player != player_name):
			obj_parent.color = color_black
			obj_parent.set_color_to_player()

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	use_time = actual_time
	time_last_used = actual_time
	active_skill = true
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	#ink_proj = load(ink_path).instance()
	#getWorld().add_child(ink_proj)
	#ink_proj.position = player.position

func _process(delta):
	if (!active_skill):
		return
	actual_time = OS.get_ticks_msec()
	if (actual_time - use_time >= active_time):
		active_skill = false
		player.get_node("MovementModule").useForcedSpeed = false
		return
	var moveModule = player.get_node("MovementModule")
	player.get_node("MovementModule").useForcedSpeed = true
	player.get_node("MovementModule").forcedSpeed = moveModule.speed * 3
