tool
extends GridContainer

enum controlModes {
	MOUSE,
	JOYSTICK
}

enum player {
	MAX = 4,
	MIN = 2
}

export(String, FILE) var next_scene_path = ""
var actualMode = controlModes.JOYSTICK
var nbOfPlayer = 0
var deviceList = []
var panelList = []
var playerRdy = []
var elapsedTime = []

func _init():
	panelList = get_children()

func join(device):
	if (nbOfPlayer > player.MAX || deviceList.has(device)):
		return
	if (panelList.size() == 0):
		panelList = get_children()
	deviceList.append(device)
	elapsedTime.append(0)
	panelList[nbOfPlayer].changeState()
	nbOfPlayer += 1
	get_tree().set_input_as_handled()

func _input(event):
	print(event.as_text(), event.device)
	print(event.device)
	if (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		actualMode = controlModes.JOYSTICK
		join(event.device)
#		

# warning-ignore:unused_argument
func _process(delta):
	for i in range(deviceList.size()):
			var hor = Input.get_joy_axis(deviceList[i], JOY_AXIS_0)
			if (playerRdy.has(deviceList[i])):
				continue
			if (OS.get_ticks_msec() - elapsedTime[i]) > 500:
				if hor > 0.2:
					panelList[i].rightChar()
					elapsedTime[i] = OS.get_ticks_msec()
				elif hor < -0.2: 
					panelList[i].leftChar()
					elapsedTime[i] = OS.get_ticks_msec()
			if (Input.is_joy_button_pressed(deviceList[i], JOY_BUTTON_0) && !playerRdy.has(deviceList[i])):
				playerRdy.append(deviceList[i])
	if playerRdy.size() == nbOfPlayer && playerRdy.size() > player.MIN:
		get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next scene path must be set for the game to start" if next_scene_path == "" else ""
