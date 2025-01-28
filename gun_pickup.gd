extends Area2D
class_name PickUp

@export var weapon : PackedScene
@export var dash : PackedScene

var hover = false

func _on_mouse_entered() -> void:
	hover = true

func _on_mouse_exited() -> void:
	hover = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if hover:
				on_click()

func on_click():
	Global.gun_manager.add(weapon, dash)
	queue_free()
