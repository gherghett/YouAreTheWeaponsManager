extends StaticBody2D

signal took_damage

var hp = 200.0 : 
	set(new_val):
		hp = new_val
		took_damage.emit()
		if(hp <= 0):
			queue_free()

func destruct(val:float):
	hp -= val
	
