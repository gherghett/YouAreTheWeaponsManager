extends Area2D

var min = 0
var max = 9

signal output

var step_index = 0 :
	set(val) :
		$KnobHead.rotation_degrees = remap(val, 0, 9, -180.0-45.0, 45.0)

var crank_is_grabbed = false
var hover = false
var can_grab = false


func _process(delta: float) -> void:
	if hover:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			can_grab = true
		elif can_grab and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			crank_is_grabbed = true
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			crank_is_grabbed = false
			
	if crank_is_grabbed:
		$KnobHead.look_at(Global.mouse_follower.position)
		var rot = $KnobHead.rotation_degrees
		rot = clamp(rot, -180.0-45.0, 45.0)
		var index = round(remap(rot, -180.0-45.0, 45.0, 0, 9))
		step_index = index
		output.emit(index)


func _on_area_entered(area: Area2D) -> void:
	if area is MouseFollower:
		hover = true

func _on_area_exited(area: Area2D) -> void:
	if area is MouseFollower:
		hover = false
		can_grab = false
