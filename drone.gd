extends Area2D

@onready var perspective_node: Node2D = $Node

const SHOOT_LINE = preload("res://shoot_line.tscn")
const DRONE_SHOT = preload("res://drone_shot.mp3")

const max_speed = 10

func _process(delta: float) -> void:
	
	var old_pos = position
	#position = get_global_mouse_position()
	var target = get_global_mouse_position()
	position = lerp(position, target, 0.1)
	var diff = (position - old_pos)
	if diff.length() > max_speed:
		position = old_pos + diff.normalized() * max_speed
	#if (position - Global.tank.position).length() > 300:
		#position = lerp(position, Global.tank.position, 0.1)
	
	var x_diff = old_pos.x - position.x
	var y_diff = old_pos.y - position.y
	var standard_y = -45
	var standard_scale = 0.5
	perspective_node.rotation_degrees = lerp(perspective_node.rotation_degrees, standard_y - x_diff*3, 0.3)
	perspective_node.scale.y = lerp(perspective_node.scale.y, clamp(standard_scale - y_diff/30, 0.2, 0.8), 0.3)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"): #TODO add delay or smth
		#print("from process")
		fire()

			
func fire():
	#print("fireee")
	SoundStage.play_at_location_var(DRONE_SHOT, position, 0.5)
	
	var shoot_line = SHOOT_LINE.instantiate()
	Global.main.smoke.add_child(shoot_line)
	shoot_line.global_position = $Node.global_position
	shoot_line.points[1] = global_position - $Node.global_position
	var timer = Timer.new()
	timer.wait_time = 0.2
	add_child(timer)
	timer.start()
	timer.timeout.connect(shoot_line.queue_free)
	timer.timeout.connect(timer.queue_free)
	
	if has_overlapping_bodies():
		var bodies = Util.distinct(get_overlapping_bodies())
		for body in bodies:
			#print("a body, ", body)
			if body.has_method("destruct"):
				shoot_line.points[1] = body.global_position - $Node.global_position
				body.destruct(10)
				break


func _on_body_entered(body: Node2D) -> void:
	#print(body.name, " entered") #
	pass # Replace with function body.
