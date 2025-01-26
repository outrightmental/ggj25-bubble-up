extends Node

# All available signals -- use these constants to reference them to avoid typos
var BUBBLE_EXIT = "bubble_exit"
var BUBBLE_SPAWN = "bubble_spawn"
var BUBBLE_VANISH = "bubble_vanish"
var UPDATE_SCORE = "update_score"
var UPDATE_TOTAL_AIR_MASS = "update_total_air_mass"
var UPDATE_WASTED_AIR_MASS = "update_wasted_air_mass"


# Keeping track of all the air in play -- we are keeping all global game logic right here in the event bus
@onready var air_total_mass: float = 0
@onready var air_vanished_mass: float = 0
@onready var air_exit_masses: Array[float] = []


func bubble_spawn(mass:float):
	air_total_mass += mass
	emit_signal(BUBBLE_SPAWN, mass)
	_recompute_score()


func bubble_vanish(mass:float):
	air_vanished_mass += mass
	emit_signal(BUBBLE_VANISH, mass)
	_recompute_score()


func bubble_exit(mass:float):
	air_exit_masses.append(mass)
	emit_signal(BUBBLE_EXIT, mass)
	_recompute_score()


func update_score(score:float):
	emit_signal(UPDATE_SCORE, score)


func update_wasted_air_mass(mass:float):
	emit_signal(UPDATE_WASTED_AIR_MASS, mass)
	
	
func _recompute_score():
	var exited_mass:float = 0
	for e in air_exit_masses:
		exited_mass += e
	var score:float = air_exit_masses.max() if air_exit_masses.size() > 0 else 0
	emit_signal(UPDATE_SCORE, score)
	emit_signal(UPDATE_WASTED_AIR_MASS, air_vanished_mass + exited_mass - score)
	emit_signal(UPDATE_TOTAL_AIR_MASS, air_total_mass)
