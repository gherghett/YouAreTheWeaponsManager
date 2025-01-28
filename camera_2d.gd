extends Camera2D

@export var follow : Node2D 

var zoom_step = 0.05

func _process(delta: float) -> void:
	global_position = Global.tank.global_position
	if Input.is_action_just_released("zoom_in") and zoom.x < 1:
		zoom.x += zoom_step
		zoom.y += zoom_step
	if Input.is_action_just_released("zoom_out") and zoom.x > 0.1:
		zoom.x -= zoom_step
		zoom.y -= zoom_step
