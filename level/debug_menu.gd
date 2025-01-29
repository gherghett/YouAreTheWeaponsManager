extends CanvasLayer

var invincible = false

func _ready() -> void:
	Global.debug = self

func _on_freeze_button_pressed() -> void:
	Global.xp_mng.add_debug("Freeze")
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("invincible")):
		print("invicle")
		invincible = not invincible
		if(invincible):
			Global.hp = 100


func _on_gattling_button_pressed() -> void:
	Global.xp_mng.add_debug("Gattling")
