extends UpgradeSetting

@export var hp : int
#we can ad other stats here 

func use():
	Global.hp += hp
	#and well add all the stats here
