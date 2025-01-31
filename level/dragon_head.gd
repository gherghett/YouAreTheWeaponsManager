extends CharacterBody2D

enum Becomes {
	MINE,
	CHERRY,
}

@export var becomes : Becomes = Becomes.MINE
@export var traveling_dir : Refs.Direction = Refs.Direction.E
@export var follow_tank : bool = false

signal took_damage
var hp = 30.0
var head_direction : Refs.Direction = Refs.Direction.S
var speed = 120
const textures_for_body = {
	Becomes.CHERRY: preload("res://Enemies/dragon/drangon_body_red.png"),
	Becomes.MINE : preload("res://Enemies/dragon/drangon_body.png"),
}
const to_become = {
	Becomes.CHERRY: preload("res://Enemies/cherry/cherry.tscn"),
	Becomes.MINE :preload("res://level/mine/mine.tscn"),
}

var time_passed: float = 0.0
var movement_direction: float = 0.5  # Initial value
const DRAGON_BODY = preload("res://Enemies/dragon/dragon_body.tscn")
var body_parts
var length = 20

var state : Refs.EnemyStates = Refs.EnemyStates.RUNNING 

func _ready() -> void:
	for i in range(length):
		var body = DRAGON_BODY.instantiate()
		body.find_child("Sprite2D").texture = textures_for_body[becomes]
		add_child(body)
		
	body_parts = get_children().filter(func(c): return c is CharacterBody2D)
	
	z_index = len(body_parts)
	print("z: ", z_index)
	var parent = self
	for body_part in body_parts:
		body_part.global_position = global_position + Vector2(randf(), randf())
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
	if state == Refs.EnemyStates.RUNNING:
		update_movement_direction(delta)
		update_sprite_animation()

func update_movement_direction(delta: float) -> void:
	time_passed += delta * 0.5
	var base_direction: float
	
	if follow_tank:
		base_direction = (Global.tank.global_position - global_position).angle()
	else:
		base_direction = Refs.directionInRads[traveling_dir]
	
	movement_direction = base_direction + 3 * sin(time_passed) - PI
	head_direction = Util.rad_to_8dir(movement_direction)

func update_sprite_animation() -> void:
	$sprite.frame = int(head_direction)

func _physics_process(delta: float) -> void:
	if state == Refs.EnemyStates.RUNNING:
		apply_movement(delta)
		move_body_parts(delta)

func apply_movement(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(movement_direction) * speed
	move_and_slide()

func move_body_parts(delta: float) -> void:
	clear_body_parts()
	var parent_position = global_position

	for body_part in body_parts:
		var displacement = parent_position - body_part.global_position
		var direction = displacement.normalized()
		var move_speed_factor = clamp((displacement / 40.0).length_squared(), 0.0, 1.0)

		body_part.velocity = direction * speed * move_speed_factor
		body_part.move_and_slide()

		if check_collisions(body_part):
			return
			
		parent_position = body_part.global_position

func check_collisions(body_part: CharacterBody2D) -> bool:
	for i in range(body_part.get_slide_collision_count()):
		var collision = body_part.get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider == Global.tank:
			body_part.explode()
			return true  # Stop further processing
	
	return false

		
func destruct(val):
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
		var become = to_become[becomes].instantiate()
		become.global_position = b.global_position
		if becomes == Becomes.MINE:
			Global.main.ground.add_child(become)
		else:
			Global.main.on_ground.add_child(become)

		b.queue_free()
	queue_free()
		
