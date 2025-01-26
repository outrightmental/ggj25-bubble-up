extends Node

# All available signals -- use these constants to reference them to avoid typos
signal bubble_exit(mass: float)
signal bubble_spawn(mass: float)
signal bubble_vanish(mass: float)
signal reset_game
signal update_score(score: int)
signal update_total_air_mass(mass: float)
signal update_wasted_air_mass(mass: float)
# Keeping track of all the air in play -- we are keeping all global game logic right here in the event bus
@onready var air_total_mass: float = 0
@onready var air_vanished_mass: float = 0
@onready var air_exit_masses: Array[float] = []


func _ready() -> void:
	reset_game.connect(_do_reset_game)
	bubble_spawn.connect(_do_bubble_spawn)
	bubble_vanish.connect(_do_bubble_vanish)
	bubble_exit.connect(_do_bubble_exit)


func _do_reset_game() -> void:
	update_score.emit(0)
	update_total_air_mass.emit(0)
	update_wasted_air_mass.emit(0)
	air_total_mass = 0
	air_vanished_mass = 0
	air_exit_masses = []


func _do_bubble_spawn(mass: float):
	air_total_mass += mass
	_update()


func _do_bubble_vanish(mass: float):
	air_vanished_mass += mass
	_update()


func _do_bubble_exit(mass: float):
	air_exit_masses.append(mass)
	_update()


func _update():
	var exited_mass: float = 0
	for e in air_exit_masses:
		exited_mass += e
	var score: int = floor(air_exit_masses.max()) if air_exit_masses.size() > 0 else 0
	update_score.emit(score)
	update_wasted_air_mass.emit(air_vanished_mass + exited_mass - score)
	update_total_air_mass.emit(air_total_mass)
