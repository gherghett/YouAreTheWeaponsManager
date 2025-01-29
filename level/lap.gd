extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("body is TAnk: ", body is Tank, " and timer is stopped: ", $Timer.is_stopped())
	if body is Tank and $Timer.is_stopped():
		Global.level.lap += 1
		Global.level.load_lap()
		if(Global.level.lap > 1):
			$HumanCrowdSoccerX150CheerClapWhistle.play()
		var lap_label = Global.dashes.get_node("lap")
		lap_label.visible = true
		lap_label.text = "LAP " + str(Global.level.lap) + "!"
		var timer = Timer.new()
		timer.wait_time = 2.0
		add_child(timer)
		timer.start()
		timer.timeout.connect(func():
			lap_label.visible = false
			timer.queue_free()
		)
		$Timer.start()

func _ready() -> void:
	$flag.play("default")
	Refs.main_ready.connect(_on_main_ready)

func _on_main_ready():
	$flag.z_index = Util.get_absolute_z_index(Global.main.smoke) + 1
	#$lapline.z_index = Util.get_absolute_z_index(Global.main.ground) + 1
	
