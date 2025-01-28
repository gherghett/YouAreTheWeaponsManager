extends AnimatedSprite2D
const BOMB = preload("res://Tank/Gun/bomb.mp3")
func _ready() -> void:
	play()
	SoundStage.play_at_location(BOMB, position)


func _on_timer_timeout() -> void:
	$"..".queue_free()
