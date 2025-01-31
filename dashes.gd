extends CanvasLayer

var dash_index = 0;

var scrub_button_down = false;
var scubbing_acceleration = 0.3;

@onready var next_button: Button = $Next
@onready var prev_button: Button = $Prev
@onready var next_button_animation: AnimationPlayer = $NextButtonAnimation
@onready var prev_button_animations: AnimationPlayer = $PrevButtonAnimations
@onready var leftarrow: AnimatedSprite2D = $leftarrow

var next_open = false
var prev_open = false


func _ready() -> void:
	$Next.pressed.connect(next)
	$Prev.pressed.connect(prev)
	Global.dashes = self

func next():
	dash_index += 1
	dash_index = clamp(dash_index, 0, Global.gun_manager.Installed.size()-1)
	update_active_dashes()
	leftarrow.stop_arrow()
	
func prev():
	dash_index -= 1
	dash_index = clamp(dash_index, 0, Global.gun_manager.Installed.size()-1) 
	update_active_dashes()
	
func update_active_dashes():
	$DashesContainer.position.x = Global.WINDOW_WIDTH * -dash_index
	print(dash_index, $DashesContainer.position.x)
	update_next_prev_buttons()

func update_next_prev_buttons():
	print("dash_index is ", dash_index)
	print("prev dash exists: ", prev_dash_exists())
	print("next dash exists: ", next_dash_exists())
	if not next_open and next_dash_exists():
		print("playing open right")
		next_button_animation.play("open_right_button")
	elif next_open and not next_dash_exists():
		print("playing colse right")
		next_button_animation.play("close_right_button")
	#
	if not prev_open and prev_dash_exists():
		print("playing open left")
		prev_button_animations.play("open_left_button")
	elif prev_open and not prev_dash_exists():
		print("playing close left")
		prev_button_animations.play("close_left_button")
	
func next_dash_exists() -> bool:
	return dash_index < Global.gun_manager.Installed.size()-1

func prev_dash_exists() -> bool:
	return dash_index > 0

func _process(delta: float) -> void:
	%HealthBar.value = Global.hp
	%XPProgressBar.value = Global.xp_mng.progress * 100
	if scrub_button_down:
		if not $">>".button_pressed:
			scrub_button_down = false
		elif Engine.time_scale < 4.0:
			Engine.time_scale += delta * scubbing_acceleration
			$">>".text = ">> " + str(round(Engine.time_scale * 10.0)/10.0 )
	else:
		Engine.time_scale = 1
		$">>".text = ">>"
	


func _on__button_up() -> void:
	Engine.time_scale = 1
	scrub_button_down = false

func _on__button_down() -> void:
	Engine.time_scale = 2
	scrub_button_down = true
	
func open_prev():
	prev_open = true
func close_prev():
	prev_open = false
func open_next():
	next_open = true
func close_next():
	next_open = false

	
