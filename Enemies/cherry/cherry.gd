extends CharacterBody2D
const CHERRY_EXPLOSION = preload("res://Enemies/cherry/cherry_explosion.tscn")
const DEADSOUND = preload("res://Enemies/cherry/zapsplat_cartoon_comic_ruler_twang_wood_short_006_108519.mp3")
const EXPLOSION_SOUND = preload("res://Enemies/cherry/zapsplat_multimedia_game_sound_explode_glass_hit_shatter_bright_reverb_75212.mp3")

signal took_damage

const WHITE_OUT_MATERIAL = preload("res://Enemies/cherry/white_out_material.tres")
var speed = 4000
var hp = 10 : 
	set(new_value):
		hp = new_value
		if new_value <= 0:
			die()
			
var state : Refs.EnemyStates = Refs.EnemyStates.RUNNING

func _ready() -> void:
	$AnimatedSprite2D.play()
	
func _physics_process(delta: float) -> void:
	match state:
		Refs.EnemyStates.RUNNING:
			var dir =  (Global.tank.position - position).normalized()
			$AnimatedSprite2D.flip_h = dir.x > 0
			velocity =  dir * speed * delta
			move_and_slide()
			var colliders = []
			for i in get_slide_collision_count():
				var collider = get_slide_collision(i).get_collider()
				if collider.has_method("_on_body_collide"):
					collider._on_body_collide(self)
					break

func damage():
	var explosion = CHERRY_EXPLOSION.instantiate()
	Global.main.smoke.add_child(explosion)
	explosion.position = position
	var anim = explosion.find_child("AnimatedSprite2D")
	anim.play()
	anim.animation_finished.connect(explosion.queue_free)
	SoundStage.play_at_location(EXPLOSION_SOUND, position)
	die()
	print("damage")
	return 10.0

func destruct(val : float):
	print("destruct")
	took_damage.emit()
	hp -= val
	if( hp <= 0):
		Global.xp_mng.add_xp(10)
		print("added 10 xp ", self)

func die():
	if( state != Refs.EnemyStates.DEAD):
		state = Refs.EnemyStates.DEAD
		SoundStage.play_at_location(DEADSOUND, position)
		queue_free()
	
