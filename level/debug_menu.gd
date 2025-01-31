extends CanvasLayer

var invincible = false

func _ready() -> void:
	Global.debug = self

func _on_freeze_button_pressed() -> void:
	Global.xp_mng.add_debug("Freeze")
	Global.dashes.update_next_prev_buttons()
	
func _process(delta: float) -> void:
	if visible:
		if(Input.is_action_just_pressed("invincible")):
			print("invicle")
			invincible = not invincible
			if(invincible):
				Global.hp = Global.max_hp
		if(Input.is_action_just_pressed("debug_next_lap")):
			Global.level.path_follow_2d.progress = 0
			Global.tank.global_position = Util.get_position_along_path($"../Path2D", 0) + $"../Path2D".global_position

	if(Input.is_action_just_pressed("show_debug_menu")):
		visible = not visible


func _on_gattling_button_pressed() -> void:
	Global.xp_mng.add_debug("Gattling")
	Global.dashes.update_next_prev_buttons()

	
