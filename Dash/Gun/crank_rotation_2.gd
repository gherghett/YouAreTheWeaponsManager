#@tool
extends Node2D
@onready var handle_shadow: Sprite2D = $"handle shadow"

#
func _process(delta: float) -> void:
	#print("crank", rotation)
	var sprites = [handle_shadow]
	for sprite in sprites:
		sprite.rotation_degrees = -rotation_degrees
