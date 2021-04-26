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

const playerColors = [
	Color(1, 0.7, 0),
	Color(0, 0, 1),
	Color(0.4, 1, 0),
	Color(1, 0, 0.8)
]

export(String, FILE) var next_scene_path = ""
var actualMode = controlModes.JOYSTICK
var nbOfPlayer = 0
var deviceList = []
var panelList = []
var playerRdy = []
var elapsedTime = []

func _ready():
	panelList = get_children()
	for i in range(panelList.size()):
		panelList[i].setColorTexture(playerColors[i])

func join(device):
	if (nbOfPlayer > player.MAX || deviceList.has(device)):
		return
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
	if playerRdy.size() == nbOfPlayer && playerRdy.size() >= player.MIN:
		var root = get_tree().get_root()
		var next_level_resource = load("res://Scenes/MainScene.tscn")
		var next_level = next_level_resource.instance()
		root.add_child(next_level)
		for i in range(deviceList.size()):
			addPlayer(panelList[i].getChar(), deviceList[i], i)
		root.get_node("MainScene/Map/SpawnSystem").spawn_players()
		var level = root.get_node("MainScreen")
		root.remove_child(level)
		level.call_deferred("free")
		
func addPlayer(name:String, nb: int, i):
	var c = load("res://Prefabs/Characters/" + name + ".tscn").instance()
	c.name = "Player" + str(nb + 1)
	c.color = playerColors[i]
	get_tree().get_root().get_node("MainScene/Players").add_child(c)

func _get_configuration_warning() -> String:
	return "next scene path must be set for the game to start" if next_scene_path == "" else ""

