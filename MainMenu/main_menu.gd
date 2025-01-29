extends Main

@onready var button : Button = $CanvasLayer/VBoxContainer/Button
@onready var music: AudioStreamPlayer = $AudioStreamPlayer
@onready var start_rect: Control = $CanvasLayer/StartRect
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var Starfield: ColorRect = $CanvasLayer/Starfield
@onready var square_swirl: ColorRect = $CanvasLayer/SquareSwirl

var full_spinning_speed = PI/10
var time = 0.0
var spinning_speed = PI/10

func _ready() -> void:
	Global.main = self
	Global.tank_state = Refs.TankState.PAUSED
	button.pressed.connect(Global.start)
	
func _process(delta: float) -> void:
	%Tank.rotate(delta * spinning_speed)
	
	var rect = start_rect.get_global_rect()
	var mouse_position = get_viewport().get_mouse_position()
	var closest_point = mouse_position.clamp(rect.position, rect.position+rect.size)
	var distance = closest_point.distance_to(mouse_position)
	if distance < 50:
		music.pitch_scale = distance/50 
		spinning_speed = full_spinning_speed * distance/50
		time += delta * distance/50
		if(distance < 25):
			Starfield.material.set("shader_parameter/high", 1-distance/25)
			square_swirl.material.set("shader_parameter/brightness_cutoff", distance/20)
			square_swirl.material.set("shader_parameter/alpha_of_darkness", distance/25)
			$CanvasLayer/Title.modulate.a =  1 - (distance - 13) / 12
			if(distance < 12):
				$CanvasLayer/Title.modulate.a =  (distance) / 12
				#color_rect_2.material.set("shader_parameter/low", 1-distance/12)
				color_rect.color.a = distance/12
			$CanvasLayer/Desert.modulate.a = 1 - distance/25
			$CanvasLayer/ShowCredits.modulate.a  = distance/25
			print(1-distance/25)
		else:
			color_rect.color.a = 1.0
			$CanvasLayer/Desert.modulate.a = 0.0
			$CanvasLayer/Title.modulate.a = 0.0
			
			
	else:
		music.pitch_scale = 1.0
		spinning_speed = full_spinning_speed
		time += delta
		Starfield.material.set("shader_parameter/high", 0.0)
	
	
	square_swirl.material.set("shader_parameter/time", time)
	
	

	
