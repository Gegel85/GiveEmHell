extends Control
onready var coco = preload("res://Scenes/TitleScreen/CoconutBody.tscn")

func _ready():
	randomize()

func _on_Timer_timeout():
	var c = coco.instance()
	
	$Cocontainer.add_child(c)
	c.position = Vector2(randi() % int( get_viewport_rect().size.x - 75) + 75, -75)
	c.rotation = randi() % 360


func _on_SpawnStart_timeout():
	$Cooldown.start()
	$isSpeed.start()


func _on_isSpeed_timeout():
	$Cooldown.wait_time = 0.5
