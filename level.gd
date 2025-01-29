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

func _ready() -> void:
	Global.level = self
	Global.gun_manager = GunManager.new() #we do this here, bc level is reset if we die and we want this to be reset aswell
	Global.xp_mng = XP_MANAGER.instantiate()
	add_child(Global.xp_mng)
	
	Global.tank.enter_state(Refs.TankState.RUNNING)
	
func load_lap():
	var spawnpoints = get_tree().get_nodes_in_group("headspawnpoint")
	print("Its lap ", Global.level.lap, " spawning ", Global.level.lap-1, " heads." )
	for i in range(Global.level.lap-1):
		var spawn = spawnpoints[0]
		spawnpoints.remove_at(0)
		var head = HEAD.instantiate()
		head.global_position = spawn.global_position
		Global.main.ground.add_child(head)

func _process(delta: float) -> void:
	pass


func _on__button_down() -> void:
	pass # Replace with function body.
