extends Node
class_name XPManager

signal leveled_up 

var xp = 0 

var xp_to_first_lvl_up = 50

var last_lvl_up = xp
var xp_next_lvl_up = xp_to_first_lvl_up

var progress : float

var level_up_queued = false

@onready var level_up_timer: Timer = $LevelUpTimer
var available = func(u_setting : UpgradeSetting):
	if not u_setting.multiple:
		return not u_setting.used
	else:
		return true

@onready var upgrades: Node = $Upgrades

func _ready() -> void:
	Global.xp_mng = self
	
func add_xp(xp_to_add):
	xp += xp_to_add
	progress = float(xp - last_lvl_up)/float(xp_next_lvl_up - last_lvl_up)
	if xp >= xp_next_lvl_up:
		level_up_timer.start()
		
func add_xp_location(xp_to_add, location):
	#TODO animation
	add_xp(xp_to_add)


func level_up():
	var diff = xp_next_lvl_up - last_lvl_up
	last_lvl_up = xp_next_lvl_up
	xp_next_lvl_up = last_lvl_up + diff * 1.5
	
	var options = upgrades.get_children().filter(available)
	
	var stats = options.filter(func(us): return us.type == Refs.UpgradeType.STAT)
	var weapons = options.filter(func(us): return us.type == Refs.UpgradeType.WEAPON)
	progress = float(xp - last_lvl_up)/float(xp_next_lvl_up - last_lvl_up)
	
	leveled_up.emit([stats.pick_random(), weapons.pick_random()])
	if xp >= xp_next_lvl_up:
		level_up_timer.start()
	
func add_debug(thing:String):
	$Upgrades.find_child(thing).use()

	

	
