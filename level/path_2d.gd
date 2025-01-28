extends Path2D

func _ready():
	var path2d = self
	var line2d = path2d.get_node("Line2D")
	var curve = path2d.curve
	var points = []
	for i in range(curve.get_point_count()):
		points.append(curve.get_point_position(i))
	line2d.points = points
