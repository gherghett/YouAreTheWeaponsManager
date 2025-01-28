extends CanvasLayer

var dash_index = 0;

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
	
