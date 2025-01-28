extends Node2D

var freeze_time = 10.0
@onready var particles: GPUParticles2D = $particles

func button_pressed():
	if($CoolDown.is_stopped()):
		particles.global_position = Global.tank.global_position
		particles.set_emitting(true)
		$particles/ParticleTimer.start()
		Global.freeze.emit(freeze_time)
		$FreezeSound.play()
		print("Freeeze")
		$CoolDown.start()

func loading_progress():
	var time = ($CoolDown.wait_time - $CoolDown.time_left) / $CoolDown.wait_time
	return time


func _on_particle_timer_timeout() -> void:
	particles.set_emitting(false)
