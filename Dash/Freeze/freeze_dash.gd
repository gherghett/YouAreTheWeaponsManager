extends Node2D

var freeze_weapon 

func connect_weapon(weapon):
	freeze_weapon = weapon
	$dash/Button.pressed.connect(weapon.button_pressed)
	Global.freeze.emit()
	
func _process(delta: float) -> void:
	if(freeze_weapon != null):
		$dash/ProgressBar.value = freeze_weapon.loading_progress()*$dash/ProgressBar.max_value
