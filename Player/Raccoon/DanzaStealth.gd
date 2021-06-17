extends Node

var cd = 8000
var sounds
export var soundeffect: AudioStream
onready var sound_path = "res://Prefabs/SoundPlayer.tscn"
onready var load_path = "res://Prefabs/Characters/Projectile.tscn"

var casting_time = 2000
var active_time = 3000
var nb_projectiles = 6
var spawn_pos = Vector2.ZERO
var radius = 1

var time_last_used = 0
var actual_time = 0

var skill_manager
var player
var world
var active_skill = false

func _ready():
	world = get_tree().get_root().get_node("MainScene").get_node("Projectiles")
	skill_manager = get_parent().get_parent()
	player = skill_manager.get_parent()

func useSkill():
	actual_time = OS.get_ticks_msec()
	if (actual_time - time_last_used < cd && time_last_used > 0):
		return
	player.make_casting_for(casting_time, true)
	time_last_used = actual_time
	player.make_opacity(0)
	spawn_pos = player.position
	var sound = load(sound_path).instance()
	getSound().add_child(sound)
	sound.init_player(soundeffect)
	skill()

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

func _process(delta):
	if (!active_skill):
		return
	var actual_time = OS.get_ticks_msec()	
	var projectiles = self.get_children()
	if (actual_time - time_last_used >= active_time):
		active_skill = false
		player.make_opacity(1)
		for i in range(projectiles.size()):
			self.get_child(i).queue_free()
		return
	player.make_casting_for(0, true)
	var dist = spawn_pos.distance_to(player.position)
	var angle = spawn_pos.angle_to_point(player.position)
	var step = 2 * PI / nb_projectiles
	for i in range(projectiles.size()):
		var pos = spawn_pos + dist * (Vector2(radius, 0).rotated(step * i + angle))
		projectiles[i].position = pos

func skill():
	for i in range(nb_projectiles):
		var bullet = load(load_path).instance()
		self.add_child(bullet)
		bullet.position = player.position
		bullet.player = player.name
		bullet.size = 1
		bullet.speed = 1
		bullet.set_values()
		bullet.invincible = true
	active_skill = true
