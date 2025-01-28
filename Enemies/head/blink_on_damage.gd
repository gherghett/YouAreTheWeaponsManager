extends Node

# Preload the shader material to be used for blinking
const WHITE_OUT_MATERIAL = preload("res://Enemies/cherry/white_out_material.tres")

# Exports to allow customization
@export var material_node: NodePath # Node to assign the material to
@export var signal_emitting_node: NodePath # Node to assign the material to
@export var blink_signal: String  = "took_damage"# Signal to listen for on the target node

# On ready, set up the material and connect to the signal
func _ready():
	if not signal_emitting_node or not material_node:
		return
		
	if get_node(material_node) == $"../ColorRect":
		print("box")
		
	var mat_node = get_node(material_node)
	if mat_node and mat_node is Node:
		# Assign a unique duplicate of the material
		mat_node.material = WHITE_OUT_MATERIAL.duplicate()
		mat_node.material.set_shader_parameter("active", false)

	var sig_node = get_node(signal_emitting_node)
	if sig_node and sig_node is Node:
		# Connect the signal to the blink function
		if sig_node.has_signal(blink_signal):
			sig_node.connect(blink_signal, _on_blink_signal)
		else:
			push_warning("The target node does not emit the signal: %s" % blink_signal)

# Called when the signal is received
func _on_blink_signal():
	blink()

# Handle the blinking effect
func blink():
	var node = get_node(material_node)
	if not node or not node.material:
		return

	var shader = node.material as ShaderMaterial
	if not shader:
		return
	
	shader.set_shader_parameter("active", true)
	
	# Create and configure a one-shot timer
	var blink_timer = Timer.new()
	blink_timer.wait_time = 0.05
	blink_timer.one_shot = true
	blink_timer.timeout.connect(func():
		shader.set_shader_parameter("active", false)
		blink_timer.queue_free()
	)

	# Add the timer as a child and start it
	add_child(blink_timer)
	blink_timer.start()
