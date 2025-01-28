extends Area2D

var go = false
var speed = 600.0
var length : float
const FIRE = preload("res://Tank/Gun/fire.mp3")

@onready var muzzle_flash: AnimatedSprite2D = $"../muzzle_flash"
const BOMB = preload("res://Tank/Gun/bomb.tscn")
const GUNSMOKE = preload("res://Tank/Gun/gunsmoke.tscn")
const GROUND_MARK = preload("res://Tank/Gun/ground_mark.tscn")
func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if go:
		position.x += speed * delta
		print("going")
		if position.x >= length:
			position.x = length
			go = false
			impact()

func fire(how_far):
	SoundStage.play_at_location(FIRE, position)
	length = how_far
	go = true
	visible = true
	var smoke = GUNSMOKE.instantiate()
	Global.main.smoke.add_child(smoke)
	smoke.global_transform = muzzle_flash.global_transform
	


func impact():
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for body in bodies.filter(destructible):
			body.destruct(1000.0)
	var bomb = BOMB.instantiate()
	bomb.global_position = global_position
	print("impact")
	Global.main.smoke.add_child(bomb)
	var groundmark = GROUND_MARK.instantiate()
	groundmark.global_position = global_position
	Global.main.ground.add_child(groundmark)
	reset()

func reset():
	go = false
	position.x = 42.0
	visible = false
	
func destructible(body):
	return body.has_method("destruct")
