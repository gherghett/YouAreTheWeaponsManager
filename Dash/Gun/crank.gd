extends Area2D

signal output

var crank_is_grabbed = false
var hover = false
var can_grab = false
const CRANK_GROAN = preload("res://Dash/Gun/Crank_groan.mp3")


var gone_lap = false

func _process(delta: float) -> void:
	if hover:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			can_grab = true
		elif can_grab and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			crank_is_grabbed = true
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			crank_is_grabbed = false
			
	if crank_is_grabbed:
		var old_rot = $Mask/CrankRotation.rotation_degrees
		$Mask/CrankRotation.look_at(Global.mouse_follower.position)
		$middle.look_at(Global.mouse_follower.position)
		$srop_shadow.rotation = $Mask/CrankRotation.rotation
		#$"../../Path2D/PathFollow2D/Tank/Gun".rotate((rotation_degrees - old_rot)*0.001)
		output.emit(($Mask/CrankRotation.rotation_degrees - old_rot))
		
		var oldpos = posmod(old_rot, 360)
		var newpos = posmod($Mask/CrankRotation.rotation_degrees, 360)
		if( newpos > 270-30 and newpos < 270+30):
			gone_lap = true
		print("roted ", oldpos, " to ", newpos)
		if(oldpos > 90-50 and oldpos < 90+50 and (not $CrankGroan.playing or gone_lap)):
			print("sound")
			gone_lap = false
			$CrankGroan.play()
	
func _input(event: InputEvent) -> void:
	InputEvent
	#print(rotation_degrees)



func _on_area_entered(area: Area2D) -> void:
	print("entered")
	if area is MouseFollower:
		hover = true

func _on_area_exited(area: Area2D) -> void:
	if area is MouseFollower:
		hover = false
		can_grab = false
