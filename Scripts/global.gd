extends Node

const Main = "res://main.tscn"
const Main_menu = "res://MainMenu/MainMenu.tscn"
const WINDOW_WIDTH = 1152/4

signal freeze

var main : Main
var dashes : CanvasLayer
var level : Node2D
var gun_manager : GunManager
var mouse_follower : Area2D
var tank : Node
var match_mng : MatchManager
var xp_mng : XPManager
var upgrade_menu : Node

enum State {
	pre,
	started, 
	paused,
	end
}

var current_state = State.pre
var tank_state : Refs.TankState = Refs.TankState.RUNNING

var hp = 100.0 :
	set( new_val ):
		hp = new_val
		tank.took_damage.emit()
		dashes.find_child("HealthBar").value = hp
		if(new_val <= 0):
			main.enter_end()

func start():
	get_tree().call_deferred("change_scene_to_file", Main)
	
func back_to_main_menu():
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", Main_menu)
