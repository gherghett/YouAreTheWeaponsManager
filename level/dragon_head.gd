extends CharacterBody2D

signal took_damage
var hp = 30.0
var head_direction : Refs.Direction = Refs.Direction.S
var speed = 9200

const MINE = preload("res://level/mine/mine.tscn")

var time_passed: float = 0.0
var movement_direction: float = 0.5  # Initial value
const DRAGON_BODY = preload("res://Enemies/dragon/dragon_body.tscn")
var body_parts
var length = 20
func _ready() -> void:
	for i in range(length):
		var body = DRAGON_BODY.instantiate()
		add_child(body)
		
	body_parts = get_children().filter(func(c): return c is CharacterBody2D)
	
	z_index = len(body_parts)
	print("z: ", z_index)
	var parent = self
	for body_part in body_parts:
		body_part.global_position = global_position
		body_part.z_index = parent.z_index - 1
		print(body_part.z_index)
		parent = body_part
	print("d")
#var timer
#
#func _process(delta: float) -> void:
	#if visible:
		#time_passed += delta  # Accumulate time
		#oscillating_value = 1.2 + 0.5 * sin(time_passed)  
		#var shader = $ColorRect.material as ShaderMaterial
		#shader.set_shader_parameter("size", oscillating_value)
		#print(oscillating_value)  # Debugging: check t

func _process(delta: float) -> void:
	time_passed += delta * 0.5
	movement_direction = PI*sin(time_passed)
	head_direction = Util.rad_to_8dir(movement_direction)
	$sprite.frame = int(head_direction)
	
	
func _physics_process(delta: float) -> void:
	velocity = delta * Vector2.RIGHT.rotated(movement_direction) * speed
	move_and_slide()
	var parent = self
	#clear_body_parts()
	for b : CharacterBody2D in body_parts:
		var diff = parent.global_position - b.global_position
		var dir = diff.normalized()
		var move_speed = clamp((diff/40.0).length_squared(), 0.0, 1.0)
		b.velocity = dir * delta * speed * move_speed
		b.move_and_slide()
		parent = b
		
func destruc(val):
	took_damage.emit()
	hp -= val
	if hp <= 0:
		die()

func clear_body_parts():
	var index = 0
	var indicies_to_remove = []
	for b in body_parts:
		if b == null:
			indicies_to_remove.append(index)
		index += 1
	indicies_to_remove.reverse()
	for i in indicies_to_remove:
		body_parts.remove_at(i)
		
		
func die():
	clear_body_parts()
	for b in body_parts:
		var mine = MINE.instantiate()
		mine.global_position = b.global_position
		Global.main.ground.add_child(mine)
		b.queue_free()
	queue_free()
		
