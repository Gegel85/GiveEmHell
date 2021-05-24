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
const UIPlayer = preload("res://Scenes/Lobby/Panel.tscn")
const TIME_BETWEEN_CHAR_CHANGE:int = 150#in ms

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
	if !connected && hasDevice(deviceList, Device.new(device)):
		leave(device)
		
func _ready() -> void:
# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "disconnectJoy")
	for i in range(player.MAX):
		panelList[i] = UIPlayer.instance()
		deviceList[i] = -1
		elapsedTime[i] = 0
		panelList[i].setColorTexture(playerColors[i])
		add_child(panelList[i])

func join(device) -> void:
	if nbOfPlayer > player.MAX || hasDevice(deviceList, device):
		return
	var i = deviceList.find(-1)
	deviceList[i] = device
	elapsedTime[0] = 0
	if device.type == Device.DeviceType.MOUSE_KEYBOARD:
		panelList[i].setIsOwner(true)
	panelList[i].changeState()
	nbOfPlayer += 1
	get_tree().set_input_as_handled()

func leave(device) -> void:
	if nbOfPlayer == 0 || !hasDevice(deviceList, device):
		return
	var i = findDevice(deviceList, device)
	panelList[i].changeState()
	panelList[i].setIsOwner(false)
	elapsedTime[i] = 0
	if hasDevice(playerRdy, device):
		toggleRdy(device)
	deviceList[i] = -1
	nbOfPlayer -= 1
	get_tree().set_input_as_handled()	

func device_type_from_event(event):
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
			return Device.DeviceType.KEYPAD
	elif event is InputEventKey:
			return Device.DeviceType.MOUSE_KEYBOARD
	else:
			return Device.DeviceType.NON_RELEVANT

func _input(event: InputEvent) -> void:
	var device = Device.new(event.device, device_type_from_event(event))

	if (event is InputEventJoypadButton || event is InputEventKey):
#Join the lobby
		if Input.is_action_just_released("ui_accept"):
			join(device)
#Leave the lobby
		elif Input.is_action_just_released("ui_cancel"):
			if nbOfPlayer == 0:
				get_tree().change_scene("res://Scenes/ModeSelection/ModeSelection.tscn")
			if !hasDevice(playerRdy, device):
				leave(device)
				
func hasDevice(dlist, device:Device):
	for i in range(dlist.size()):
		if typeof(dlist[i]) == TYPE_INT:
			continue
		if device.eq(dlist[i]):
			return true
	return false

func findDevice(dlist, device: Device):
	for i in range(dlist.size()):
		if device.eq(dlist[i]):
			return i
	return -1

func _unhandled_input(event: InputEvent) -> void:
	var device: Device = Device.new(event.device, device_type_from_event(event))
	
	if hasDevice(deviceList, device):
		var i = findDevice(deviceList, device)
#Rdy management
		if Input.is_action_just_released("ui_accept") && !hasDevice(playerRdy, device):
			toggleRdy(device)
		if Input.is_action_just_released("ui_cancel") && hasDevice(playerRdy, device):
			toggleRdy(device)
#Swap character	
		if !hasDevice(playerRdy, device) && (OS.get_ticks_msec() - elapsedTime[i]) >= TIME_BETWEEN_CHAR_CHANGE:
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
	var i = findDevice(deviceList, device)
	
	if hasDevice(playerRdy, device):
		playerRdy.remove(i)
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
		if typeof(deviceList[i]) != TYPE_INT:
			addPlayer(panelList[i].getChar(), deviceList[i].id, i)
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

func _get_configuration_warning() -> String:
	return "next scene path must be set for the game to start" if next_scene_path == "" else ""
