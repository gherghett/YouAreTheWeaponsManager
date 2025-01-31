extends RigidBody2D

signal took_damage

const WOOD_CRUSH = preload("res://level/audio_mangler_crashes_wood_04_252.mp3")

func _ready() -> void:
	input_pickable = false
	
func _process(delta: float) -> void:
	pass
	
# very wierd! the body eats up the input, so the drone doesnt get it
#its not pickable...
#even if you delete the collisionshape it eats the input!
# this is a hack to send the result to the drone 
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			#print("collision box fire")
			#Global.main.find_child("Drone").fire()
			pass


var hp = 100.0 : 
	set(new_value):
		took_damage.emit()
		hp = new_value
		if new_value <= 0:
			die()
			
func destruct(amount:float):
	hp -= amount

	
func drive_over_destruct(amount:float):
	hp -= amount

func die():
	var sound = SoundStage.play_at_location_var(WOOD_CRUSH, global_position, 0.1)
	var start = randf()*3.0
	var playtime = randf()*0.5 + 0.5
	sound.stop()
	sound.play(start)
	var when_to_mute = Timer.new()
	when_to_mute.wait_time = playtime
	when_to_mute.timeout.connect(func():
		if sound:
			sound.volume_db = -100
		when_to_mute.queue_free()	
	)
	SoundStage.add_child(when_to_mute)
	when_to_mute.start()
	
	queue_free()
