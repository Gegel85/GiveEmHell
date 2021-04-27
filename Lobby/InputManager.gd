tool
extends GridContainer

enum player {
	MAX = 4,
	MIN = 2
}

const playerColors = [
	Color(1, 0.7, 0),
	Color(0, 0, 1),
	Color(0.4, 1, 0),
	Color(1, 0, 0.8)
]

const UIPlayer = preload("res://Lobby/Panel.tscn")
const TIME_BETWEEN_CHAR_CHANGE = 300#in ms

export(String, FILE) var next_scene_path = ""
var nbOfPlayer = 0
var deviceList = []
var panelList = []
var playerRdy = []
var elapsedTime = []

func _init():
	for i in range(player.MAX):
		panelList.append(UIPlayer.instance())
		panelList[i].setColorTexture(playerColors[i])
		add_child(panelList[i])

func join(device):
	if nbOfPlayer > player.MAX || deviceList.has(device):
		return
	deviceList.append(device)
	elapsedTime.append(0)
	panelList[nbOfPlayer].changeState()
	nbOfPlayer += 1
	get_tree().set_input_as_handled()	

func leave(device):
	if nbOfPlayer == 0 || !deviceList.has(device):
		return
	var i = deviceList.find(device)
	deviceList.remove(i)
	elapsedTime.remove(i)
	panelList[i].changeState()
	nbOfPlayer -= 1
	get_tree().set_input_as_handled()	

func _unhandled_input(event):
	var device = event.device
	
	if (event is InputEventJoypadButton || event is InputEventKey):
		if Input.is_action_just_released("ui_accept"):
			join(device)
		if Input.is_action_just_released("ui_cancel"):
			leave(device)

func _input(event):
	var device = event.device

	if deviceList.has(device):
		var i = deviceList.find(device)

		if Input.is_action_just_released("ui_accept") && !playerRdy.has(device):
			playerRdy.append(device)
		if Input.is_action_just_released("ui_cancel") && playerRdy.has(device):
			playerRdy.erase(device)
			get_tree().set_input_as_handled()	
		if playerRdy.has(device):
			return
		if (OS.get_ticks_msec() - elapsedTime[i]) < TIME_BETWEEN_CHAR_CHANGE:
			return
		if Input.is_action_pressed("ui_right"):
			panelList[i].rightChar()
			elapsedTime[i] = OS.get_ticks_msec()
		elif Input.is_action_pressed("ui_left"):
			panelList[i].leftChar()
			elapsedTime[i] = OS.get_ticks_msec()
	if playerRdy.size() == nbOfPlayer && playerRdy.size() >= player.MIN:
		var root = get_tree().get_root()
		
		loadScene(next_scene_path)
		for i in range(deviceList.size()):
			addPlayer(panelList[i].getChar(), deviceList[i], i)
		root.get_node("MainScene/Map/SpawnSystem").spawn_players()
		unloadScene("MainScene")

func loadScene(path):
	var root = get_tree().get_root()
	var next_level = load(path).instance()

	root.add_child(next_level)
	return next_level

func unloadScene(node):
	var root = get_tree().get_root()
	var level = root.get_node(node)

	root.remove_child(level)
	level.call_deferred("free")

func addPlayer(name:String, nb: int, i: int):
	var c = load("res://Prefabs/Characters/" + name + ".tscn").instance()

	c.name = "Player" + str(nb + 1)
	c.color = playerColors[i]
	get_node("/MainScene/Players").add_child(c)

func _get_configuration_warning() -> String:
	return "next scene path must be set for the game to start" if next_scene_path == "" else ""
