extends CharacterBody2D
var hp = 15.0
var state : Refs.EnemyStates = Refs.EnemyStates.RUNNING

const CHERRY_EXPLOSION = preload("res://Enemies/cherry/cherry_explosion.tscn")
const EXPLOSION_SOUND = preload("res://Enemies/cherry/zapsplat_multimedia_game_sound_explode_glass_hit_shatter_bright_reverb_75212.mp3")


signal took_damage 

func destruct(val):
	hp -= val
	took_damage.emit()
	if hp <= 0:
		queue_free()

func explode():
	Global.hp -= 20.0
	var explosion = CHERRY_EXPLOSION.instantiate()
	Global.main.smoke.add_child(explosion)
	explosion.position = position
	var anim = explosion.find_child("AnimatedSprite2D")
	anim.play()
	anim.animation_finished.connect(explosion.queue_free)
	SoundStage.play_at_location(EXPLOSION_SOUND, position)
	queue_free()
