extends Node2D

var number
var character
var device = Device.new(-1)
var invincible = false
var casting = false
var invincibility_duration = 1000
var cast_duration = 1000
var start_invincible = 0
var start_cast = 0
export var color = Color()
var playerUI

func _ready():
	number = int(self.get_name().split("Player")[1])
	$Appearance.modulate = color
	var UI = get_tree().get_root().get_node("MainScene").get_node("UIContainer").get_node("Popup")
	playerUI = UI.getUI(self.get_name())
	playerUI.init(self)

func make_casting_for(time, slow):
	if (slow):
		$MovementModule.speed = $MovementModule.focusedSpeed
	casting = true
	start_cast = OS.get_ticks_msec()
	cast_duration = time

func make_opacity(op):
	$Appearance.modulate.a = op
	$SkillsModule/Direction.modulate.a = op

func make_invincible_for(duration):
	invincible = true
	start_invincible = OS.get_ticks_msec()
	invincibility_duration = duration

func take_damage(dmg):
	if (invincible):
		return
	$Lifebar.take_damage(1)
	playerUI.setLife($Lifebar.get_life())
	make_invincible_for(2000)
	$Appearance.modulate.a = 0.5

func _physics_process(delta):
	$MovementModule.moveAround()
	$SkillsModule.Aim()
	if (!invincible && !casting):
		$SkillsModule.SkillActivator()
	check_still_invincible()
	check_still_casting()

func check_still_casting():
	if (!casting || cast_duration == -1):
		return
	var actual_time = OS.get_ticks_msec()
	if (actual_time - start_cast >= cast_duration):
		$MovementModule.speed = $MovementModule.base_speed
		casting = false

func check_still_invincible():
	if (!invincible):
		return
	var actual_time = OS.get_ticks_msec()
	if (actual_time - start_invincible >= invincibility_duration):
		$Appearance.modulate.a = 1
		invincible = false
