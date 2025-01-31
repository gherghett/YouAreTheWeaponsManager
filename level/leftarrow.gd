extends AnimatedSprite2D

var time_passed: float = 0.0
var oscillating_value: float = 0.5  # Initial value

var timer

func _process(delta: float) -> void:
	if visible:
		time_passed += delta  # Accumulate time
		oscillating_value = 1.2 + 0.5 * sin(time_passed)  
		var shader = $ColorRect.material as ShaderMaterial
		shader.set_shader_parameter("size", oscillating_value)
		print(oscillating_value)  # Debugging: check the oscillating value
		
func start():
	if not visible:
		play()
		visible = true
		timer = Timer.new()
		timer.wait_time = 6.0
		add_child(timer)
		timer.start()
		timer.timeout.connect(stop_arrow)

func stop_arrow():
	visible = false
	if timer != null:
		timer.queue_free()
