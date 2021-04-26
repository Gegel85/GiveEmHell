extends Node

var rng = RandomNumberGenerator.new()
var nb_spawns = 0

func _ready():
	nb_spawns = get_child_count()	
	rng.randomize()
	spawn_players()

func spawn_players():
	var start_spawn = rng.randf_range(0, nb_spawns)
	var players = get_parent().get_node("Players").get_children()
	var nb_player = 0
	for player in players:
		player.position = get_child(int(int(start_spawn + nb_player) % nb_spawns)).position
		nb_player += 1

func get_random_spawn():	
	return get_child(rng.randf_range(0, nb_spawns)).position
	
