extends CharacterBody2D
var hp = 15.0
var state : Refs.EnemyStates = Refs.EnemyStates.RUNNING

signal took_damage 

func destruct(val):
	hp -= val
	took_damage.emit()
	if hp <= 0:
		queue_free()
