extends Node2D

const MACHINE_GUN = preload("res://Tank/RotationRattle/machine_gun.mp3")

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var muzzle_animation: AnimatedSprite2D = $RayCast2D/ColorRect/AnimatedSprite2D
@onready var line_2d: Line2D = $RayCast2D/Line2D
const BULLET = preload("res://Tank/Gattling/bullet.tscn")

signal update_meter

var shot_damage = 10.0

var max_ammo = 50
var ammo = 0
var timer_between_shots = 0.0
var muzzle_flash_animation = 0.05
var muzzle = muzzle_flash_animation  

var fire_rate = 0.1
var trigger = false


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
			
	timer_between_shots -= delta
	if trigger:
		if (timer_between_shots <= 0.0 ):
			fire()
			timer_between_shots = fire_rate
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"): #TODO add delay or smth
		#print("from process")
		trigger = true
	if event.is_action_released("shoot"):
		trigger = false
		
		
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed:
		#if event.button_index == MOUSE_BUTTON_LEFT :
			#print("Left mouse button")
			#fire()
	
	
func fire():

	if ammo <= 0:
		return
	ammo -= 1
	update_meter.emit(ammo)
	#print("fireing, ammo: ", ammo)
	SoundStage.play_at_location_var(MACHINE_GUN, position, 0.1)
	muzzle_flash()
	
	
	$BulletStartPosition
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = $BulletStartPosition.global_position
	new_bullet.rotation = global_rotation
	add_child(new_bullet)
	
	##ray_cast_2d.visible = not ray_cast_2d.visible
	#ray_cast_2d.force_raycast_update()
	#if ray_cast_2d.is_colliding():
		#var collider = ray_cast_2d.get_collider()
		#if collider.has_method("destruct"):
			#var length = (Global.tank.position + ray_cast_2d.position - collider.position ).length()
			#if length < 200.0 :
				#line_2d.points[1].x = length
			#collider.destruct(shot_damage)
	
func button_pressed():
	ammo = max_ammo
	update_meter.emit(ammo)


func _on_fire_rate_timeout() -> void:
	if ammo > 0:
		fire()

func muzzle_flash():
	line_2d.visible = true
	muzzle_animation.visible = true
	muzzle_animation.set_frame_and_progress(randi_range(0, 3), randf())
	muzzle_animation.play()
	muzzle = muzzle_flash_animation
	muzzle_animation.rotation = randf()/3
