extends Node2D

@onready var crank_distance: Area2D = $Crank_distance
@onready var crank_rotation: Area2D = $Crank
@onready var safety: CheckButton = $safety
@onready var fire_button: Button = $fireButton

func connect_weapon(weapon):
	crank_distance.output.connect(weapon._on_crank_distance_output)
	crank_rotation.output.connect(weapon._on_crank_output)
	fire_button.pressed.connect(weapon._on_fire_pressed)
	weapon.dash = self
	
	
	
