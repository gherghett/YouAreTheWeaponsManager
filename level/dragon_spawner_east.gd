extends Area2D

const DRAGON_HEAD = preload("res://Enemies/dragon/dragon_head.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body == Global.tank and $Timer.is_stopped():
		$Timer.start()
		var dragon = DRAGON_HEAD.instantiate()
		dragon.global_position = $spawnpoint.global_position
		dragon.traveling_dir = Refs.Direction.S
		
		if Global.level.lap > 1:
			dragon.becomes = dragon.Becomes.CHERRY
			
		Global.main.ground.add_child(dragon)
		
		if Global.level.lap > 2:
			dragon = DRAGON_HEAD.instantiate()
			dragon.global_position = $spawnwest.global_position
			dragon.follow_tank = true
			
			if Global.level.lap > 3:
				dragon.becomes = dragon.Becomes.CHERRY
			
			Global.main.ground.add_child(dragon)
			
