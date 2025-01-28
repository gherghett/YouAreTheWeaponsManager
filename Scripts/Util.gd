extends Node

func distinct(list : Array):
	var seen = {}
	for item in list:
		seen[item] = true 
	return seen.keys()
