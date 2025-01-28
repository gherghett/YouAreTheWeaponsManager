@tool
extends Node2D
@export var parent: Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	#print("parent", parent.global_rotation)
	
	rotation = -parent.global_rotation
	for child in get_children():
		child.rotation = parent.global_rotation
	#print("asd",  global_rotation)
