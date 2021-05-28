tool
extends AbstractLobby


func init():
	panelList.resize(player.MAX)
	deviceList.resize(player.MAX)
	elapsedTime.resize(player.MAX)
	throttleAccept.resize(player.MAX)
	throttleLeave.resize(player.MAX)

func _init() -> void:
	init()
	# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "disconnectJoy")
	
func disconnectJoy(device, connected) -> void:
	if !connected && hasDevice(deviceList, Device.new(device)):
		leave(device)

func _ready() -> void:
# warning-ignore:return_value_discarded
	ready()

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
			if !hasDevice(playerRdy, device) && hasDevice(deviceList, device):
				var i = findDevice(deviceList, device)
				if (OS.get_ticks_msec() - throttleLeave[i]) > THROTTLE_ACCEPT:
					leave(device)

func _unhandled_input(event: InputEvent) -> void:
	var device: Device = Device.new(event.device, device_type_from_event(event))
	
	if hasDevice(deviceList, device):
		var i = findDevice(deviceList, device)
		if i == -1:
			return
#Rdy management
		if Input.is_action_just_released("ui_accept") && !hasDevice(playerRdy, device) && (OS.get_ticks_msec() - elapsedTime[i]) > THROTTLE_ACCEPT:
			toggleRdy(device)
			throttleAccept[i] = OS.get_ticks_msec()
		if Input.is_action_just_released("ui_cancel") && hasDevice(playerRdy, device):
			toggleRdy(device)
			throttleLeave[i] = OS.get_ticks_msec()
#Swap character	
		if !hasDevice(playerRdy, device) && (OS.get_ticks_msec() - elapsedTime[i]) >= TIME_BETWEEN_CHAR_CHANGE:
			if event is InputEventJoypadMotion && abs(event.axis_value) <= 0.1:
				return 
			if Input.is_action_pressed("ui_right"):
				panelList[i].rightChar()
				elapsedTime[i] = OS.get_ticks_msec()
			elif Input.is_action_pressed("ui_left"):
				panelList[i].leftChar()
				elapsedTime[i] = OS.get_ticks_msec()
#Start game
	if playerRdy.size() >= player.MIN:
		start()
