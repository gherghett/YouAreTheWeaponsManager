extends StaticBody2D
const CHERRY_EXPLOSION = preload("res://Enemies/cherry/cherry_explosion.tscn")
const DEADSOUND = preload("res://Enemies/cherry/zapsplat_cartoon_comic_ruler_twang_wood_short_006_108519.mp3")
const EXPLOSION_SOUND = preload("res://Enemies/cherry/zapsplat_multimedia_game_sound_explode_glass_hit_shatter_bright_reverb_75212.mp3")
const RING_OF_FIRE = preload("res://Enemies/head/ring_of_fire.tscn")

var state : Refs.EnemyStates = Refs.EnemyStates.WAITING : 
	set(new_state) :
		if(new_state == state):
			return
		exit_state(state)
		match new_state:
			Refs.EnemyStates.WAITING:
				pass
			Refs.EnemyStates.RUNNING:
				$Timer.start()
				pass
			Refs.EnemyStates.FROZEN:
				pass
			Refs.EnemyStates.DEAD:
				pass
		state = new_state

signal took_damage

@onready var right_eye: Line2D = $rightEye
@onready var right_eye_2: Line2D = $rightEye2
@onready var right_eye_laser_2: Line2D = $rightEye_laser2
@onready var right_eye_laser: Line2D = $rightEye_laser

var rof

var speed = 40
var hp = 500.0 : 
	set(new_value):
		hp = new_value
		if new_value <= 0:
			die()



func _ready() -> void:
	#enter_state(Refs.EnemyStates.RUNNING)
	pass

#func enter_state(new_state : Refs.EnemyStates):

			
func exit_state(old_state : Refs.EnemyStates):
	match old_state:
		Refs.EnemyStates.WAITING:
			$AnimatedSprite2D.play("awake")
		Refs.EnemyStates.RUNNING:
			$Timer.stop()
			close_eyes()
			$AnimationPlayer.stop()

func _process(delta: float) -> void:
	var dir =  (Global.tank.position - position)
	match state:
		Refs.EnemyStates.WAITING:
			if dir.length() < 400:
				state = Refs.EnemyStates.RUNNING
	#$AnimatedSprite2D.flip_h = dir.x > 0
	#position += dir * speed * delta

func eyes_on_tank():
	right_eye_laser_2.visible = true
	right_eye_laser.visible = true
	for eye in [right_eye, right_eye_2, right_eye_laser, right_eye_laser_2]:
		eye.points[1] = Global.tank.global_position - global_position
	
func fire():
	right_eye.visible = true
	right_eye_2.visible = true
	right_eye_laser_2.visible = false
	right_eye_laser.visible = false
	
	rof = RING_OF_FIRE.instantiate()
	rof.fireer = self
	Global.main.ground.add_child(rof)
	rof.find_child("AnimatedSprite2D").play()
	rof.global_position = right_eye.points[1] + global_position
	
func close_eyes():
	right_eye.visible = false
	right_eye_2.visible = false
	right_eye_laser_2.visible = false
	right_eye_laser.visible = false
	
	if rof != null:
		rof.queue_free()
	
	
#func damage():
	#var explosion = CHERRY_EXPLOSION.instantiate()
	#Global.main.smoke.add_child(explosion)
	#explosion.position = position
	#var anim = explosion.find_child("AnimatedSprite2D")
	#anim.play()
	#anim.animation_finished.connect(explosion.queue_free)
	#SoundStage.play_at_location(EXPLOSION_SOUND, position)
	#die()
	#return 10.0

func destruct(val : float):
	hp -= val
	if state == Refs.EnemyStates.DEAD:
		Global.xp_mng.add_xp(100)
	took_damage.emit()

func die():
	#SoundStage.play_at_location(DEADSOUND, position)
	
	queue_free()
	


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("aaaaa")
