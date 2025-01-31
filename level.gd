extends Node2D

@onready var tank_follow: Node2D = %Tank_Follow
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
var lap = 0 #currently run laps, should affect diffuculty

const GUN : PackedScene = preload("res://Tank/Gun/gun.tscn") 
const ROTATION_RATTLE = preload("res://Tank/RotationRattle/rotation_rattle.tscn")
const GUN_DASH = preload("res://Dash/Gun/gun_dash.tscn")
const ROTATION_RATTLE_DASH = preload("res://Dash/RotationRattle/rotation_rattle_dash.tscn")
const XP_MANAGER = preload("res://Upgrades/XPManager.tscn")
const HEAD = preload("res://Enemies/head/head.tscn")
const BOX = preload("res://level/Obsticles/box.tscn")
const MINE = preload("res://level/mine/mine.tscn")
const CHERRY = preload("res://Enemies/cherry/cherry.tscn")

func _ready() -> void:
	Global.level = self
	Global.gun_manager = GunManager.new() #we do this here, bc level is reset if we die and we want this to be reset aswell
	Global.xp_mng = XP_MANAGER.instantiate()
	add_child(Global.xp_mng)
	Global.tank.enter_state(Refs.TankState.RUNNING)
	#%UpgradeMenu.visible = false #sometimes when restarting this is an issue
	
func load_lap():
	if (lap % 3 == 0):
		var things_to_turn = get_tree().get_nodes_in_group("turn_into")
		for thing in things_to_turn:
			var pos = thing.global_position
			thing.queue_free()
			var cherry = CHERRY.instantiate()
			Global.main.on_ground.add_child(cherry)
			cherry.global_position = pos
			
	var spawnpoints = get_tree().get_nodes_in_group("headspawnpoint")
	print("Its lap ", Global.level.lap, " spawning ", Global.level.lap-1, " heads." )
	for i in range(Global.level.lap-1):
		if len(spawnpoints) == 0:
			break
		var spawn = spawnpoints[0]
		spawnpoints.remove_at(0)
		var head = HEAD.instantiate()
		head.global_position = spawn.global_position
		Global.main.ground.add_child(head)
	
	var boxspawnpoints = get_tree().get_nodes_in_group("boxspawnpoint")
	for i in range(randi_range(1, Global.level.lap+2)):
		if len(boxspawnpoints) > 0:
			var spawn = boxspawnpoints.pick_random()
			boxspawnpoints.remove_at(boxspawnpoints.bsearch(spawn))
			for j in range(randi_range(0,1)*Global.level.lap*2*randi_range(1,3)):
				var box : RigidBody2D = BOX.instantiate()
				box.global_position = spawn.global_position + (Vector2.RIGHT * randf()*100*3).rotated(randf()*2*PI)
				Global.main.on_ground.add_child(box)
				while box.get_contact_count() > 0:
					box.position.x += 20
	
			
	#mines
	if(lap > 1):
		var numberofmines = 3 + int(lap * 1.5)
		for i in range(numberofmines):
			var mine_position = Util.get_position_along_path($Path2D, randf()) + $Path2D.position
			var mine = MINE.instantiate()
			mine.global_position = mine_position
			Global.main.ground.add_child(mine)
			
		

func _process(delta: float) -> void:
	pass


func _on__button_down() -> void:
	pass # Replace with function body.
