extends Camera2D

export var active = true

func calculateOffsetZoom(players):
	var screenSize = OS.window_size
	var maxX = 0.0
	var maxY = 0.0
	var minX = 1920.0
	var minY = 1080.0
	var scaling = 1.0
	var Xscaling = 1.0
	var Yscaling = 1.0
	var map = get_node("/root/MainScene/Map")
	var topLeft = map.get_node("TopLeftCorner")
	var bottomRight = map.get_node("BottomRightCorner")

	for player in players:
		minX = min(player.position.x - 50, minX)
		minY = min(player.position.y - 320, minY)
		maxX = max(player.position.x + 50, maxX)
		maxY = max(player.position.y + 320, maxY)
#	minX = max(minX, topLeft.position.x)
#	minX = max(minY, topLeft.position.y)
#	maxX = min(maxX, bottomRight.position.x)
#	maxY = min(maxY, bottomRight.position.y)
	Xscaling = (maxX - minX) / screenSize.x
	Yscaling = (maxY - minY) / screenSize.y
	scaling = max(max(Xscaling, Yscaling), 0.5)
	offset.x = minX + screenSize.x * (Xscaling - scaling) / 2
	offset.y = minY + screenSize.y * (Yscaling - scaling) / 2
	zoom = Vector2(scaling, scaling)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!active):
		return
	var players = get_node("/root/MainScene/Players").get_children()
	var screenSize = OS.window_size

	if players.empty():
		zoom = Vector2(1, 1)
		offset = Vector2(0, 0)
	elif players.size() == 1:
		zoom = Vector2(1, 1)
		offset.x = players[0].position.x - screenSize.x / 2
		offset.y = players[0].position.y - screenSize.y / 2
	else:
		calculateOffsetZoom(players)
