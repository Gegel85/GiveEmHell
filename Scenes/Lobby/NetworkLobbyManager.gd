extends AbstractLobby

onready var settingsNode = get_node("/root/Settings")
var currI = 0

func _init():
	init()

func _ready():
	ready()
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	if get_tree().is_network_server():
		var event_type = Device.DeviceType.MOUSE_KEYBOARD
		if settingsNode.get_setting("keybind", "controller"):
			event_type = Device.DeviceType.KEYPAD
		join(Device.new(0, event_type))

func _connected_ok():
	pass

func add_player():
	for i in range(4):
		if join(Device.new(i)):
			return i

func _player_connected(id):
	if get_tree().get_network_unique_id() == id:
		return
	var new_player = add_player()
	if get_tree().is_network_server():
		var ui_array = []
		for panel in panelList:
			ui_array.append(panel.characterIndex)
		rpc_id(id, "init_list", deviceList, ui_array, playerRdy, new_player)

func _player_disconnected(id):
	pass
	
func _connected_fail():
	pass
	
func _server_disconnected():
	pass

remote func init_list(deviceL, ui_arr, rdyList, index):
	deviceList = deviceL
	currI = index
	for i in range(player.MAX):
		if typeof(deviceL[i]) == TYPE_INT:
			panelList[i].characterIndex = ui_arr[i]
			panelList[i].changeState()
			if i in rdyList:
				panelList[i].toggleRdy()
