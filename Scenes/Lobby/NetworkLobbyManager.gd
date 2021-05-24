extends GridContainer

enum player {
	MAX = 4,
	MIN = 1
}

const playerColors = [
	Color(1, 0.7, 0),
	Color(0, 0, 1),
	Color(0.4, 1, 0),
	Color(1, 0, 0.8)
]
const UIPlayer = preload("res://Scenes/Lobby/PanelNetwork.tscn")
const TIME_BETWEEN_CHAR_CHANGE:int = 300#in ms

export(String, FILE) var next_scene_path = ""
var nbOfPlayer: int = 0
var deviceList = []
var panelList = []
var playerRdy = []
var elapsedTime = []

func _init() -> void:
	panelList.resize(player.MAX)
	deviceList.resize(player.MAX)
	elapsedTime.resize(player.MAX)

func disconnectJoy(device, connected) -> void:
	if !connected && deviceList.has(device):
		leave(device)
		
func _ready() -> void:
# warning-ignore:return_value_discarded
	for i in range(player.MAX):
		panelList[i] = UIPlayer.instance()
		deviceList[i] = -1
		elapsedTime[i] = 0
		panelList[i].setColorTexture(playerColors[i])
		add_child(panelList[i])
	join(0)

func join(device) -> void:
	if nbOfPlayer > player.MAX || deviceList.has(device):
		return
	var i = deviceList.find(-1)
	deviceList[i] = device
	elapsedTime[0] = 0
	if device == 0:
		panelList[i].setIsOwner(true)	
	panelList[i].changeState()
	nbOfPlayer += 1
	get_tree().set_input_as_handled()

func leave(device) -> void:
	if nbOfPlayer == 0 || !deviceList.has(device):
		return
	var i = deviceList.find(device)
	panelList[i].changeState()
	elapsedTime[i] = 0
	if playerRdy.has(device):
		toggleRdy(device)
	deviceList[i] = -1
	nbOfPlayer -= 1
	get_tree().set_input_as_handled()	

func _unhandled_input(event: InputEvent) -> void:
	var device: int = event.device

	if deviceList.has(device):
		var i = deviceList.find(device)
#Rdy management
		if Input.is_action_just_pressed("ui_accept") && !playerRdy.has(device):
			toggleRdy(device)
		if Input.is_action_just_pressed("ui_cancel") && playerRdy.has(device):
			toggleRdy(device)
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

func toggleRdy(device) -> void: 
	var i = deviceList.find(device)
	
	if playerRdy.has(device):
		playerRdy.erase(device)
	else:
		playerRdy.append(device)
	panelList[i].toggleRdy()
	
func isRdy() -> bool:
	return playerRdy.size() == nbOfPlayer && nbOfPlayer != 0

func start() -> void:
	var root = get_tree().get_root()
	
	if !isRdy():
		return
	var level = loadScene(next_scene_path)
	get_tree().set_current_scene(level)
	for i in range(player.MAX):
		if deviceList[i] != -1:
			addPlayer(panelList[i].getChar(), deviceList[i], i)
	root.get_node("MainScene/Map/SpawnSystem").spawn_players()
	root.get_node("TitleScreenMusic").stop()
	unloadScene("MainScreen")

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

func addPlayer(name:String, nb: int, i: int) -> void:
	var c = load("res://Prefabs/Characters/" + name + ".tscn").instance()
	var root = get_tree().get_root()
	
	c.name = "Player" + str(nb + 1)
	c.color = playerColors[i]
	root.get_node("MainScene/Players").add_child(c)
