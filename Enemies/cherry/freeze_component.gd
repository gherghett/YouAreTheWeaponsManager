extends Node

@export var freezecolor : Color = Color.BLUE
@export var enemy_path : NodePath
@export var sprite_path : NodePath
var enemy 
var sprite
var sprite_play_state_before_freezing
var enemy_state_before_freezing

func _ready() -> void:
	Global.freeze.connect(freeze)
	enemy = get_node(enemy_path)
	sprite = get_node(sprite_path)

func freeze(time):
	sprite.modulate = freezecolor
	if sprite is AnimatedSprite2D:
		sprite_play_state_before_freezing = sprite.is_playing()
		sprite.pause()
	enemy_state_before_freezing = enemy.state
	enemy.state = Refs.EnemyStates.FROZEN
	var freeze_timer = Timer.new()
	add_child(freeze_timer)
	freeze_timer.wait_time = time
	freeze_timer.start()
	freeze_timer.timeout.connect(thaw)
	freeze_timer.timeout.connect(freeze_timer.queue_free)
	
func thaw():
	sprite.modulate = Color.WHITE
	if sprite is AnimatedSprite2D:
		if sprite_play_state_before_freezing:
			sprite.play()
	enemy.state = enemy_state_before_freezing
