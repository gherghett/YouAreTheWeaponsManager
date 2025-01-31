extends Area2D

const CHERRY_EXPLOSION = preload("res://Enemies/cherry/cherry_explosion.tscn")
const EXPLOSION_SOUND = preload("res://Enemies/cherry/zapsplat_multimedia_game_sound_explode_glass_hit_shatter_bright_reverb_75212.mp3")


func _process(delta: float) -> void:
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body == Global.tank:
				explode(Global.tank)
				
func explode(tank):
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.has_method("destruct"):
				body.destruct(20)
	
	Global.hp -= damage()
	var explosion = CHERRY_EXPLOSION.instantiate()
	Global.main.smoke.add_child(explosion)
	explosion.position = position
	var anim = explosion.find_child("AnimatedSprite2D")
	anim.play()
	anim.animation_finished.connect(explosion.queue_free)
	SoundStage.play_at_location(EXPLOSION_SOUND, position)
	queue_free()

func damage():
	return 20
	
#func destruct(_val):
	#pass
	#var stack = get_stack()
	#if stack.size() > 1:
		#print("Called by:", stack[1].source)  # This gives you the script file path of the caller
		#if stack[1].source == "res://drone.gd":
			#die()

func clear_mine():
	die()
			
func die():
	queue_free()
