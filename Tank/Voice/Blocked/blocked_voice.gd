extends Node2D

func play():
	if $CoolDown.is_stopped():
		$Sounds.get_children().pick_random().play()
		$CoolDown.start()
