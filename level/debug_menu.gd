extends CanvasLayer



func _on_freeze_button_pressed() -> void:
	Global.xp_mng.add_debug("Freeze")


func _on_gattling_button_pressed() -> void:
	Global.xp_mng.add_debug("Gattling")
