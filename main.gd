extends Main

@onready var on_ground: Node2D = $level/OnGround
@onready var ground: Node2D = $level/Ground
@onready var smoke: Node2D = $level/Smoke

@onready var path_follow_2d: PathFollow2D = $level/Path2D/PathFollow2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer

const INTRO_LEVEL = preload("res://level/intro_level.tscn")
@onready var upgrade_menu: Panel = %UpgradeMenu

func _ready() -> void:
	Global.main = self
	Global.upgrade_menu = upgrade_menu
	enter_pre()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu"):
		enter_paused()
	
	if Global.current_state == Global.State.pre:
		pre(delta)
	elif Global.current_state == Global.State.started:
		started(delta)
	elif Global.current_state == Global.State.paused:
		paused(delta)
	elif Global.current_state == Global.State.end:
		end(delta)

func enter_pre():
	Global.current_state = Global.State.pre
	$CanvasLayer.visible = true
	get_tree().paused = true
	%StartMenu.visible = true
	%RestartMenu.visible = false
	%PauseMenu.visible = false

func pre(delta):
	pass

func enter_started():
	Global.current_state = Global.State.started
	get_tree().paused = false
	$CanvasLayer.visible = false
	%RestartMenu.visible = false
	%StartMenu.visible = false
	%PauseMenu.visible = false

func started(delta):
	pass

func enter_paused():
	get_tree().paused = true
	$CanvasLayer.visible = true
	%RestartMenu.visible = false
	%StartMenu.visible = false
	%PauseMenu.visible = true
	
func paused(delta):
	pass
	
func enter_end():
	$CanvasLayer.visible = true
	get_tree().paused = true
	Global.current_state = Global.State.end
	%RestartMenu.visible = true
	
func end(delta):
	pass
	

func _on_button_pressed() -> void:
	%StartMenu.visible = false
	enter_started()

func _on_restart_button_pressed() -> void:
	%RestartMenu.visible = false
	var name = $level.name
	$level.queue_free()
	remove_child($level)
	var new_level = INTRO_LEVEL.instantiate()
	new_level.name = name
	add_child(new_level)
	move_child(new_level, 0)
	on_ground = $level/OnGround
	ground = $level/Ground
	smoke = $level/Smoke
	path_follow_2d = $level/Path2D/PathFollow2D
	canvas_layer = $CanvasLayer
	Global.hp = 100.0 #TODO
	
	enter_started()

func _on_main_menu_pressed() -> void:
	Global.back_to_main_menu()
