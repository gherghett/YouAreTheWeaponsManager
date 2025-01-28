extends StaticBody2D

var hp = 200.0 : 
	set(new_val):
		hp = new_val
		if(hp <= 0):
			queue_free()

func destruct(val:float):
	hp -= val
	
