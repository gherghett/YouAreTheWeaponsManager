extends Node
class_name GunManager

var Guns : Dictionary
var Dashs : Dictionary
var Installed : Array

func _ready() -> void:
	Global.dashes

func add(weapon : PackedScene, dash : PackedScene) -> void:
	var w = weapon.instantiate()
	var d = dash.instantiate()
	
	if Guns.has(w.name):
		return
	if Dashs.has(d.name):
		return
		
	var offset = Global.WINDOW_WIDTH *( Installed.size() )
	
	Guns[w.name] = w
	Global.tank.add_child(w)
	d.position.x = offset
	Installed.append(d)
	Dashs[d.name] = d
	Global.dashes.find_child("DashesContainer").add_child(d)
	d.connect_weapon(w)
