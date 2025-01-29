extends Area2D
const CHERRY = preload("res://Enemies/cherry/cherry.tscn")
var spawn_timer = 0.0
var distance = 600.0
func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer < 0 and tank_is_in() :
		var cherry = CHERRY.instantiate()
		Global.main.ground.add_child(cherry)
		cherry.global_position = Global.tank.global_position + random_dir() * distance 
		spawn_timer = randf() * 6 
		if(Global.level.lap > 0):
			spawn_timer = spawn_timer / (Global.level.lap + 1)

func random_dir():
	return Vector2(randf()-0.5, randf()-0.5).normalized()
	
func tank_is_in() -> bool:
	if has_overlapping_bodies():
		if get_overlapping_bodies().count(Global.tank) == 1:
			return true
	return false
