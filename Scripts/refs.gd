extends Node

enum UpgradeType {
	WEAPON,
	STAT
}

enum TankState {
	RUNNING,
	BLOCKED,
	FROZEN,
	PAUSED
}

enum EnemyStates {
	WAITING,
	RUNNING, 
	FROZEN,
	DEAD
}

enum Direction {
	E,
	SE,
	S,
	SW,
	W,
	NW,
	N,
	NE
}

signal main_ready
