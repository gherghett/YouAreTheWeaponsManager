extends Node2D

@onready var tank_follow: Node2D = %Tank_Follow
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

const GUN : PackedScene = preload("res://Tank/Gun/gun.tscn") 
const ROTATION_RATTLE = preload("res://Tank/RotationRattle/rotation_rattle.tscn")
const GUN_DASH = preload("res://Dash/Gun/gun_dash.tscn")
const ROTATION_RATTLE_DASH = preload("res://Dash/RotationRattle/rotation_rattle_dash.tscn")
const XP_MANAGER = preload("res://Upgrades/XPManager.tscn")

func _ready() -> void:
	Global.level = self
	Global.gun_manager = GunManager.new() #we do this here, bc level is reset if we die and we want this to be reset aswell
	Global.xp_mng = XP_MANAGER.instantiate()
	add_child(Global.xp_mng)
	
	Global.tank.enter_state(Refs.TankState.RUNNING)

func _process(delta: float) -> void:
	pass
