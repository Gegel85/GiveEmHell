extends Node2D

var number
var device = Device.new(0)
var invincible = false
var invincibility_duration = 1000
var start_invincible = 0
export var color = Color()

func _ready():
	number = int(self.get_name().split("Player")[1])
	$Appearance.modulate = color

func make_invincible_for(duration):
	invincible = true
	start_invincible = OS.get_ticks_msec()
	invincibility_duration = duration

func take_damage(dmg):
	if (invincible):
		return
	$Lifebar.take_damage(dmg)
	make_invincible_for(1000)
	$Appearance.modulate.a = 0.5

func _physics_process(delta):
	$MovementModule.moveAround()
	$SkillsModule.Aim()
	$SkillsModule.SkillActivator()
	check_still_invincible()

func check_still_invincible():
	if (!invincible):
		return
	var actual_time = OS.get_ticks_msec()
	if (actual_time - start_invincible >= invincibility_duration):
		$Appearance.modulate.a = 1
		invincible = false
