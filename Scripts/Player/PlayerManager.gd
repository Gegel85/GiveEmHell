extends Node2D

var number
var invincible = false
var invincibility_duration = 2000
var start_invincible = 0

func _ready():
	number = int(self.get_name().split("Player")[1])

func take_damage(dmg):
	if (invincible):
		return
	$Lifebar.take_damage(dmg)
	invincible = true
	start_invincible = OS.get_ticks_msec()
	$Appearance.modulate.a = 0.5

func _physics_process(delta):
	$MovementModule.moveAround(self, number - 1)
	$SkillsModule.Aim(number - 1)
	$SkillsModule.SkillActivator(number - 1)
	check_still_invincible()

func check_still_invincible():
	if (!invincible):
		return
	var actual_time = OS.get_ticks_msec()
	if (actual_time - start_invincible >= invincibility_duration):
		$Appearance.modulate.a = 1
		invincible = false
