extends Node2D

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$MovementModule.moveAround(self)
	$SkillsModule.Aim()

