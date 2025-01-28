extends Node2D

const MACHINE_GUN = preload("res://Tank/RotationRattle/machine_gun.mp3")

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var muzzle_animation: AnimatedSprite2D = $RayCast2D/ColorRect/AnimatedSprite2D
@onready var line_2d: Line2D = $RayCast2D/Line2D

var rotating_speed_setting = 1
var burst_setting = 1
var shot_damage = 10.0

var max_ammo = 10
var ammo = 0
var timer_between_shots = 0.0
@onready var fire_rate =  $Reload.wait_time / max_ammo /  burst_setting 
@export var rot_speed_step = 30.0

var muzzle_flash_animation = 0.05
var muzzle = muzzle_flash_animation  

func set_rot_speed(val : int) :
	rotating_speed_setting = val
	
func set_burst_speed(val : int) :
	burst_setting = val
	fire_rate =  $Reload.wait_time / max_ammo /  burst_setting 
	print("set burst to ", val, "set fire rate to", fire_rate)
	
func _process(delta: float) -> void:
	var deg = rot_speed_step * (rotating_speed_setting-4) * delta
	var rad = deg_to_rad(deg)
	ray_cast_2d.rotate(rad)
	#print("rotated ", deg, "in rad ", rad)
	
	if(muzzle > 0):
		muzzle -= delta
		if(muzzle < 0):
			muzzle_animation.visible = false
			line_2d.visible = false
			line_2d.points[1].x = 128.0
	
	timer_between_shots += delta
	if (timer_between_shots > fire_rate):
		_on_fire_rate_timeout()
		timer_between_shots = 0.0
	
func fire():
	ammo -= 1
	#print("fireing, ammo: ", ammo)
	SoundStage.play_at_location(MACHINE_GUN, position)
	muzzle_flash()
	
	#ray_cast_2d.visible = not ray_cast_2d.visible
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		if collider.has_method("destruct"):
			var length = (Global.tank.position + ray_cast_2d.position - collider.position ).length()
			if length < 200.0 :
				line_2d.points[1].x = length
			collider.destruct(shot_damage)
	
func _on_reload_timeout() -> void:
	print("reload")
	ammo = max_ammo

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
