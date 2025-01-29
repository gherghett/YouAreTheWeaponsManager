extends Node

static func distinct(list : Array):
	var seen = {}
	for item in list:
		seen[item] = true 
	return seen.keys()
	
static func get_absolute_z_index(target: Node2D) -> int:
	var node = target;
	var z_index = 0;
	while node and node.is_class('Node2D'):
		z_index += node.z_index;
		if !node.z_as_relative:
			break;
		node = node.get_parent();
	return z_index;
