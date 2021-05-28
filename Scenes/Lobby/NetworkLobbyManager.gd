extends AbstractLobby

onready var settingsNode = get_node("/root/Settings")

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
