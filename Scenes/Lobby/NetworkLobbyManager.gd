extends AbstractLobby

onready var settingsNode = get_node("/root/Settings")
var currI = 0
var isConnected = false
var idArr = [1]
onready var backButton = get_tree().get_root().get_node("MainScreen/ButtonContainer/BackButton")

func _init():
	init()
	idArr.resize(player.MAX)

func _ready():
	ready()
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	if get_tree().is_network_server():
		join(Device.new(0))

func _connected_ok():
	print('conn')

func add_player():
	for i in range(player.MAX):
		if join(Device.new(i)):
			return i

func _player_connected(id):
	if id < 1:
		return
	if id == 1:
		isConnected = true
		return
	var new_player = add_player()
	if get_tree().is_network_server():
		var ui_array = []
		idArr[new_player] = id
		for panel in panelList:
			ui_array.append(panel.characterIndex)
		rpc_id(id, "init_list", deviceList, ui_array, playerRdy, new_player)

func _player_disconnected(id):
	if get_tree().is_network_server():
		var i = idArr.find(id)
		leave(deviceList[i])
		rpc_id(id, "leave", deviceList[i])

func _connected_fail():
	pass
	
func _server_disconnected():
	pass

remote func init_list(deviceL, ui_arr, rdyList, index):
	deviceList = deviceL
	currI = index
	print(currI)
	for i in range(player.MAX):
		if typeof(deviceL[i]) != TYPE_INT:
			panelList[i].characterIndex = ui_arr[i]
			panelList[i].changeState()
			if i in rdyList:
				panelList[i].toggleRdy()

func _input(event: InputEvent) -> void:
	var device = Device.new(currI)

	if (event is InputEventJoypadButton || event is InputEventKey):
#Leave the lobby
		if Input.is_action_just_released("ui_cancel"):
			if !findDevice(deviceList, device) in playerRdy && hasDevice(deviceList, device):
				var i = findDevice(deviceList, device)
				if (OS.get_ticks_msec() - throttleLeave[i]) > THROTTLE_ACCEPT:
					backButton._onButtonUp()
					

func _unhandled_input(event: InputEvent) -> void:
	var device = Device.new(currI)
	
	if hasDevice(deviceList, device):
		var i = findDevice(deviceList, device)
		if i == -1:
			return
#Rdy management
		if Input.is_action_just_released("ui_accept") && !findDevice(deviceList, device) in playerRdy && (OS.get_ticks_msec() - elapsedTime[i]) > THROTTLE_ACCEPT:
			rpc("toggleRdy", device)
			throttleAccept[i] = OS.get_ticks_msec()
		if Input.is_action_just_released("ui_cancel") && findDevice(deviceList, device) in playerRdy:
			rpc("toggleRdy", device)
			throttleLeave[i] = OS.get_ticks_msec()
#Swap character	
		if !findDevice(deviceList, device) in playerRdy && (OS.get_ticks_msec() - elapsedTime[i]) >= TIME_BETWEEN_CHAR_CHANGE:
			if event is InputEventJoypadMotion && abs(event.axis_value) <= 0.1:
				return 
			if Input.is_action_pressed("ui_right"):
				rpc("rightChar")
				elapsedTime[i] = OS.get_ticks_msec()
			elif Input.is_action_pressed("ui_left"):
				rpc("leftChar")
				elapsedTime[i] = OS.get_ticks_msec()
#Start game
	if playerRdy.size() >= player.MIN:
		start()

remotesync func rightChar(i):
	panelList[i].rightChar()
	
remotesync func leftChar(i):
	panelList[i].leftChar()
