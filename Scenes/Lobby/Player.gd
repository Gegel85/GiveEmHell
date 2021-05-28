extends Node

class_name Player

var device: Device
var ui
var is_ready: bool = false

func _init(device, ui):
	device = device
	ui = ui
