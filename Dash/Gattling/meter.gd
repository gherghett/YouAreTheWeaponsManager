extends Node2D

var max : int = 100
var current : int = 0
@onready var pin_rotation_max = $Pin.rotation_degrees
#var pin_rotation_current = pin_rotation_zero

func _ready() -> void:
	update_pin(current)

func update_pin(ammo):
	current = ammo
	$Pin.rotation_degrees =  float(current)/float(max) * pin_rotation_max
	#print($Pin.rotation_degrees)
