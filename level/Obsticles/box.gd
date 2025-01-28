extends RigidBody2D

signal took_damage

func _ready() -> void:
	input_pickable = false
	
func _process(delta: float) -> void:
	pass
	
# very wierd! the body eats up the input, so the drone doesnt get it
#its not pickable...
#even if you delete the collisionshape it eats the input!
# this is a hack to send the result to the drone 
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			#print("collision box fire")
			#Global.main.find_child("Drone").fire()
			pass


var hp = 100.0 : 
	set(new_value):
		took_damage.emit()
		hp = new_value
		if new_value <= 0:
			die()
			
func destruct(amount:float):
	hp -= amount

	
func drive_over_destruct(amount:float):
	hp -= amount

func die():
	queue_free()
