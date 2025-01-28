#@tool
extends Node2D
#
#
func _process(delta: float) -> void:
	#print("crank", rotation)
	var sprites = get_children()
	for sprite in sprites:
		sprite.rotation = -rotation
