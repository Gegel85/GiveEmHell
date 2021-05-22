extends TextureButton

func _ready():
	connect("mouse_entered", self, "onHover")
	connect("mouse_exited", self, "onExitHover")
	connect("button_down", self, "onPress")
	connect("button_up", self, "onRelease")

func onHover():
	get_child(0).OutLine = Color(0.65,0.03, 0.03, 1)

func onExitHover():
	get_child(0).OutLine = Color(0.89,0.88, 0.2, 1)
	
func onPress():
	$AnimationPlayer.play("onPress")
	
func onRelease():
	$AnimationPlayer.play("onRelease")

func _draw():
	var size = .get_size()
	var pos = $Polygon2D.get_position()

	if pos.x != size.x / 2 || pos.y != size.y / 2:
		$Polygon2D.set_position(Vector2(size.x / 2, size.y / 2))
