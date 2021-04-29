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
	panelList.resize(player.MAX)
	deviceList.resize(player.MAX)
	elapsedTime.resize(player.MAX)
	for i in range(player.MAX):
		panelList[i] = UIPlayer.instance()
		deviceList[i] = -1
		elapsedTime[i] = 0
		panelList[i].setColorTexture(playerColors[i])
		add_child(panelList[i])

func disconnectJoy(device, connected):
	if !connected && deviceList.has(device):
		leave(device)
		
func _ready():
	Input.connect("joy_connection_changed", self, "disconnectJoy")

func join(device):
	if nbOfPlayer > player.MAX || deviceList.has(device):
		return
	var i = deviceList.find(-1)
	deviceList[i] = device
	elapsedTime[0] = 0
	panelList[i].changeState()
	nbOfPlayer += 1
	get_tree().set_input_as_handled()	

func leave(device):
	if nbOfPlayer == 0 || !deviceList.has(device):
		return
	var i = deviceList.find(device)
	panelList[i].changeState()
	elapsedTime[i] = 0
	if playerRdy.has(device):
		playerRdy.erase(device)
	deviceList[i] = -1
	nbOfPlayer -= 1
	get_tree().set_input_as_handled()	

func _input(event):
	var device = event.device
	
	if (event is InputEventJoypadButton || event is InputEventKey):
#Join the lobby
		if Input.is_action_just_released("ui_accept"):
			join(device)
#Leave the lobby
		elif Input.is_action_just_released("ui_cancel") && !playerRdy.has(device):
			leave(device)

func _unhandled_input(event):
	var device = event.device

	if deviceList.has(device):
		var i = deviceList.find(device)
#Rdy management
		if Input.is_action_just_released("ui_accept") && !playerRdy.has(device):
			playerRdy.append(device)
		if Input.is_action_just_released("ui_cancel") && playerRdy.has(device):
			playerRdy.erase(device)
#Swap character	
		if !playerRdy.has(device) && (OS.get_ticks_msec() - elapsedTime[i]) >= TIME_BETWEEN_CHAR_CHANGE:
			if Input.is_action_pressed("ui_right"):
				panelList[i].rightChar()
				elapsedTime[i] = OS.get_ticks_msec()
			elif Input.is_action_pressed("ui_left"):
				panelList[i].leftChar()
				elapsedTime[i] = OS.get_ticks_msec()
#Start game
	if playerRdy.size() >= player.MIN:
		start()

func isRdy() -> bool:
	return playerRdy.size() == nbOfPlayer && nbOfPlayer != 0

func start():
	var root = get_tree().get_root()
	
	if !isRdy():
		return
	loadScene(next_scene_path)
	for i in range(player.MAX):
		if deviceList[i] != -1:
			addPlayer(panelList[i].getChar(), deviceList[i], i)
	root.get_node("MainScene/Map/SpawnSystem").spawn_players()
	unloadScene("MainScreen")	

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
	var root = get_tree().get_root()
	
	c.name = "Player" + str(nb + 1)
	c.color = playerColors[i]
	root.get_node("MainScene/Players").add_child(c)

func _get_configuration_warning() -> String:
	return "next scene path must be set for the game to start" if next_scene_path == "" else ""
