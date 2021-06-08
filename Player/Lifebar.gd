extends Sprite

var HP = 4
var HP_max = 4

var respawn = 4
var heal_tic = 0
var heal_val = 0

var last_heal_time = 0
var max_scale = 0.978
var pos_max = 0.105
var pos_min = -244.37

func _ready():
	display_health_bar()
	pass # Replace with function body.

func navigate(scene):
	var level = loadScene(scene)
	get_tree().set_current_scene(level)
	get_tree().get_root().get_node("TitleScreenMusic").play()	
	unloadScene("MainScene")

func loadScene(path: String):
	var root = get_tree().get_root()
	var next_level = load(path).instance()

	root.add_child(next_level)
	return next_level

func unloadScene(node: String) -> void:
	var root = get_tree().get_root()
	var level = root.get_node(node)

	root.remove_child(level)
	level.call_deferred("free")


func get_life():
	return HP

func display_health_bar():
	var percent = float(HP) / HP_max
	$Energy.scale.x = max_scale * percent
	$Energy.position.x = pos_min + ((pos_max + (pos_min * -1)) * percent)

func out_of_life():
	respawn -= 1
	if respawn == 0:
		get_parent().playerUI.set_transparent()
		get_parent().queue_free()
		if get_parent().get_parent().get_child_count() == 2:
			navigate("res://Scenes/Lobby/Lobby.tscn")
		return
	var spawner_pos = get_tree().get_root().get_node("MainScene/Map/SpawnSystem").get_random_spawn()
	get_parent().position = spawner_pos
	HP = HP_max
	display_health_bar()

func take_damage(nb):
	if (HP - nb <= HP_max):
		HP -= nb
	else:
		HP = HP_max
	if (HP <= 0):
		HP = 0
		out_of_life()
	display_health_bar()

func _process(delta):
	if (HP == HP_max):
		return
	var actual_time = OS.get_ticks_msec()
	if (actual_time - last_heal_time < heal_tic):
		return
	last_heal_time = actual_time
	take_damage(heal_val * -1)
