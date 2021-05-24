enum DeviceType {
	KEYPAD,
	MOUSE_KEYBOARD,
	NON_RELEVANT
}

class_name Device

var id: int setget set_id, get_id
var type: int setget set_type, get_type
	
func _init(id: int, type := DeviceType.KEYPAD):
	self.id = id
	self.type = type

func eq(device:Device):
	return id == device.id && type == device.type

func set_id(value):
	id = value
	
func get_id():
	return id

func set_type(value):
	type = value
	
func get_type():
	return type
