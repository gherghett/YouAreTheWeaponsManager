extends Panel

@onready var canvas_layer: CanvasLayer = $".."
@onready var items: VBoxContainer = $Items

func _ready() -> void:
	Global.upgrade_menu = self
	Global.xp_mng.leveled_up.connect(Global.upgrade_menu.upgrade)

func upgrade(options):
	$UpgradeChime.play()
	get_tree().paused = true
	var timer = Timer.new()
	timer.wait_time = 0.6
	add_child(timer)
	timer.start()
	timer.timeout.connect(func(): activate(options))
	timer.timeout.connect(timer.queue_free)
	

func activate(options):
	canvas_layer.visible = true
	visible = true
	$UpgradeBg.play(randf()*20)
	
	for o in options.filter(func(op): return op != null):
		var new_button = Button.new()
		items.add_child(new_button)
		new_button.text = o.desc
		new_button.pressed.connect(o.use)
		new_button.pressed.connect(close)
	
func close():
	get_tree().paused = false
	canvas_layer.visible = false
	visible = false
	for child in items.get_children().filter(func(c) : return c is Button):
		items.remove_child(child)
	$UpgradeBg.stop()
	$UpgradeChime.stop()
	Global.dashes.update_next_prev_buttons()
	
	
