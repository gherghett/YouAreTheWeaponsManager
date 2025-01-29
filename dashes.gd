extends CanvasLayer

var dash_index = 0;

var scrub_button_down = false;
var scubbing_acceleration = 0.3;

func _ready() -> void:
	$Next.pressed.connect(next)
	$Prev.pressed.connect(prev)
	Global.dashes = self

func next():
	dash_index += 1
	dash_index = clamp(dash_index, 0, Global.gun_manager.Installed.size()-1)
	update_active_dashes()
	
func prev():
	dash_index -= 1
	dash_index = clamp(dash_index, 0, Global.gun_manager.Installed.size()-1) 
	update_active_dashes()
	
func update_active_dashes():
	$DashesContainer.position.x = Global.WINDOW_WIDTH * -dash_index
	print(dash_index, $DashesContainer.position.x)
	
func _process(delta: float) -> void:
	%HealthBar.value = Global.hp
	%XPProgressBar.value = Global.xp_mng.progress * 100
	if scrub_button_down:
		if not $">>".button_pressed:
			scrub_button_down = false
		elif Engine.time_scale < 4.0:
			Engine.time_scale += delta * scubbing_acceleration
			$">>".text = ">> " + str(round(Engine.time_scale * 10.0)/10.0 )
	else:
		Engine.time_scale = 1
		$">>".text = ">>"
	


func _on__button_up() -> void:
	Engine.time_scale = 1
	scrub_button_down = false

func _on__button_down() -> void:
	Engine.time_scale = 2
	scrub_button_down = true
