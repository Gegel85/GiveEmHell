extends Node2D

func _ready():
	pass # Replace with function body.

func _draw():
	pass

func shape_laser(player):
	var dir = player.get_node("SkillsModule").angle_aim
	var pos = Vector2(cos(dir), sin(dir)) * 2000
	draw_line(player.position, pos, Color(255, 0, 0), 10)

func draw_laser(player):
	self.connect("_draw", self, "shape_laser", [player])

func _process(delta):
	update()	
