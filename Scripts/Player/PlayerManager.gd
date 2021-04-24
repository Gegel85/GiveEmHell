extends Node2D

var number

func _ready():
	number = int(self.get_name().split("Player")[1])


func _physics_process(delta):
	$MovementModule.moveAround(self, number - 1)
	$SkillsModule.Aim(number - 1)
	$SkillsModule.SkillActivator(number - 1)
