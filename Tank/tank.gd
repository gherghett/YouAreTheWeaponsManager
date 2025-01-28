extends CharacterBody2D

############# TANK

signal took_damage

@export var speed = 25
var distance_until_blocked = 150
@onready var gun: Node2D = $Gun
@onready var shell: Area2D = $Gun/Shell
@onready var blocked_voice: Node2D = $Voice/Blocked

var time_blocked = 0.0

func _ready() -> void:
	Global.tank = self
	
func _on_crank_distance_output(crank) -> void:
	gun._on_crank_distance_output(crank)

func _on_crank_output(crank) -> void:
	gun._on_crank_output(crank)

#func _on_area_entered(area: Area2D) -> void:
	#if area.has_method("damage"):
		#Global.hp -= area.damage()
		
func _on_body_collide(body) -> void:
	if body.has_method("damage"):
		Global.hp -= body.damage()

func _process(delta: float) -> void:
	match Global.tank_state:
		Refs.TankState.RUNNING:
			time_blocked = 0.0
			running(delta)
		Refs.TankState.BLOCKED:
			blocked(delta)

func _physics_process(delta: float) -> void:
	match Global.tank_state:
		Refs.TankState.PAUSED:
			pass
		_:
			var calculated_speed = speed
			if(dir_to_follow().length() < 25):
				calculated_speed *= 0.3
			velocity = calculated_speed * 100 * delta * Vector2.RIGHT.rotated(rotation)
			move_and_slide()
			var colliders = []
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				var collider = collision.get_collider()
				colliders.append(collider)
				if collider.is_in_group("pushable"):
					push(collider, collision, calculated_speed* 100 * delta * Vector2.RIGHT.rotated(rotation))
			
			for collider in Util.distinct(colliders):
				if collider.has_method("drive_over_destruct"):
					collider.drive_over_destruct(30*delta)
					
			var target_rotation = global_position.angle_to_point(Global.level.tank_follow.global_position)
			var rotation_speed = PI/2
			if(dir_to_follow().length() > 5):
				pass
				#print("rotation: ", rotation, " target: ", target_rotation)
			rotation = rotate_toward(rotation, target_rotation, rotation_speed*delta)
			

func push(body : RigidBody2D, collision : KinematicCollision2D, force):
	body.apply_force(force, collision.get_position())

func dir_to_follow():
	return (Global.level.tank_follow.global_position - global_position)

func running(delta):
	var distance = dir_to_follow().length()
	if(distance < distance_until_blocked):
		Global.level.path_follow_2d.progress += speed * delta
	if(distance >= distance_until_blocked):
		enter_state(Refs.TankState.BLOCKED)

func blocked(delta):
	time_blocked += delta
	var distance = dir_to_follow().length()
	if(distance < distance_until_blocked):
		enter_state(Refs.TankState.RUNNING)
	
	

########### ENTER STATE
func enter_state(new_state : Refs.TankState):
	if(new_state == Global.tank_state):
		return
	match new_state:
		Refs.TankState.RUNNING:
			pass
		Refs.TankState.BLOCKED:
			blocked_voice.play()
			print("entering blocked")
	Global.tank_state = new_state
