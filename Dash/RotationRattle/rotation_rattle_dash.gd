extends Node2D
@onready var burst_knob: Area2D = $dash/Burst_knob
@onready var rotation_knob: Area2D = $dash/Rotation_Knob

func _ready() -> void:
	burst_knob.step_index = 1
	rotation_knob.step_index = 1

func connect_weapon(weapon):
	burst_knob.output.connect(weapon.set_burst_speed)
	rotation_knob.output.connect(weapon.set_rot_speed)
	
	
