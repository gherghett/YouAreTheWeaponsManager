extends Node2D


func connect_weapon(weapon):
	$dash/Button.pressed.connect(weapon.button_pressed)
	weapon.update_meter.connect($dash/Meter.update_pin)
	$dash/Meter.max = weapon.max_ammo
	
