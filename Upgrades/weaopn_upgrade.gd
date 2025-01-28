extends UpgradeSetting
class_name WeaponUpgradeSetting

@export var weapon : PackedScene
@export var dash : PackedScene

func use():
	Global.gun_manager.add(weapon, dash)
	used = true
	
	
