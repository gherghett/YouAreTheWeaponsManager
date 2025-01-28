extends Node2D


func connect_weapon(weapon):
	$dash/Button.pressed.connect(weapon.button_pressed)
	
