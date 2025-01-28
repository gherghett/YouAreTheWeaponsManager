extends Area2D
class_name MouseFollower

func _ready() -> void:
	Global.mouse_follower = self


func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()
