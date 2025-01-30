extends Node2D
var rotation_speed = PI/3.0
var min_distance = 200.0
var max_distance = 1100.0
@onready var marker_2d: Marker2D = $"Marker2D"
@onready var distance = marker_2d.position.x

@onready var line_2d: Line2D = $Line2D
@onready var shell: Area2D = $"Shell"

var dash : Node #the corresponding dash

#@onready var safety: CheckButton = Global.dashes.find_child("safety")
@onready var muzzle_flash: AnimatedSprite2D = $muzzle_flash
#const GUNSMOKE = preload("res://gunsmoke.tscn")

var gun_name = "Gun"
#var is_active = true

func _ready() -> void:
	#print("this ready")
	line_2d.points[1] = marker_2d.position
	muzzle_flash.stop()

func _process(delta: float) -> void:
	#
	#if Input.is_action_pressed("ui_left"):
		#rotate(rotation_speed * delta)
	#elif Input.is_action_pressed("ui_right"):
		#rotate(-rotation_speed * delta)
	pass

func _on_crank_output(crank : float) -> void:
	rotate(crank * 0.005)
	$Line2D.visible = true
	$Line2D/Timer.start()
	$Line2D/Timer.wait_time = 1.0

func _on_crank_distance_output(crank : float) -> void:
	marker_2d.position.x += (crank * 0.1)
	marker_2d.position.x = clamp(marker_2d.position.x, min_distance, max_distance)
	#print(line_2d.points[1])
	line_2d.points[1] = marker_2d.position
	#print(line_2d.points[1])
	#print(marker_2d.position)
	$Line2D.visible = true
	$Line2D/Timer.start()
	$Line2D/Timer.wait_time = 1.0

func _on_timer_timeout() -> void:
	$Line2D.visible = false

func _on_fire_pressed() -> void:
	if not dash.find_child("safety").button_pressed:
		print("fire")
		fire()

func fire():
	shell.fire(marker_2d.position.x)
	muzzle_flash.play()
	
