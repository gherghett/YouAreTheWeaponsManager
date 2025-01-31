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

const directionInRads = {
	Refs.Direction.E: 0,
	Refs.Direction.SE: PI / 4,
	Refs.Direction.S: PI / 2,
	Refs.Direction.SW: 3 * PI / 4,
	Refs.Direction.W: PI,
	Refs.Direction.NW: -3 * PI / 4,
	Refs.Direction.N: -PI / 2,
	Refs.Direction.NE: -PI / 4
}


signal main_ready
