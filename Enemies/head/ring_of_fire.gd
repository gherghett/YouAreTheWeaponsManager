extends Area2D

var dps = 20

var fireer : Node2D #who fired

func _process(delta: float) -> void:
	for tank in get_overlapping_bodies().filter(func(b): return b == Global.tank):
		Global.hp -= dps * delta
		
	if not fireer:
		queue_free()
		
