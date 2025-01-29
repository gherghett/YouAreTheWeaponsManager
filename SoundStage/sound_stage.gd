extends Node2D

func play_at_location(stream : AudioStream, location: Vector2) -> AudioStreamPlayer2D:
	var new_2d_audio = AudioStreamPlayer2D.new()
	
	add_child(new_2d_audio)
	
	new_2d_audio.position = location
	new_2d_audio.stream = stream
	new_2d_audio.finished.connect(new_2d_audio.queue_free)
	new_2d_audio.play()
	
	return new_2d_audio

func play_at_location_var(stream: AudioStream, location : Vector2, pitch_variance) -> AudioStreamPlayer2D:
	var new_audio = play_at_location(stream, location)
	new_audio.pitch_scale = randf_range(1-pitch_variance/2, 1+pitch_variance/2)
	
	return new_audio
	
	
var xp_dings_in_a_row = 0
func play_xp(_amount):
	$XpTimerCoolDown.start($XpTimerCoolDown.wait_time)
	xp_dings_in_a_row += 1
	var dupe = $xpding.duplicate()
	add_child(dupe)
	dupe.play()
	dupe.pitch_scale = 1.5 + (0.2 * (xp_dings_in_a_row-1))
	dupe.finished.connect(dupe.queue_free)
	
	
func _on_xp_timer_cool_down_timeout() -> void:
	xp_dings_in_a_row = 0
