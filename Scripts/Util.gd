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

static func get_position_along_path(path_2d: Path2D, progress: float) -> Vector2:
	var curve = path_2d.curve  # Get the Curve2D from Path2D
	return curve.sample_baked(progress * curve.get_baked_length())  # Get position
	
static func rad_to_8dir(rad: float) -> Refs.Direction:
	rad = fmod(rad + PI * 2, PI * 2)  # Normalize angle to [0, 2*PI]
	
	# Define 8 sectors (each 45 degrees or PI/4 radians)
	var index = int(round(rad / (PI / 4))) % 8  # Round to nearest direction
	
	# Map index to Direction enum
	var direction_map = [
		Refs.Direction.E,
		Refs.Direction.SE,
		Refs.Direction.S,
		Refs.Direction.SW,
		Refs.Direction.W,
		Refs.Direction.NW,
		Refs.Direction.N,
		Refs.Direction.NE
	]
	
	return direction_map[index]
