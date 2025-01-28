extends Area2D

var bullet_damage = 10
var speed = 700
var direction

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(rotation)

func _process(delta: float) -> void:
	position += speed * delta * direction
	
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.has_method("destruct"):
				body.destruct(bullet_damage)
				queue_free()
				break
