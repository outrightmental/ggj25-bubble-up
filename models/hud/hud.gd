extends Node2D


@onready var label_wasted_air_mass: Label = $"Lost Value"
@onready var label_score: Label = $"Score Value"


func _ready() -> void:
	Signals.connect(Signals.UPDATE_WASTED_AIR_MASS,  _update_wasted_air_mass)
	Signals.connect(Signals.UPDATE_SCORE,  _update_score)


func _update_wasted_air_mass(mass: float) -> void:
	label_wasted_air_mass.text = str(mass)


func _update_score(score: float) -> void:
	label_score.text = str(score)


func _on_navigate_main() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_navigate_reset() -> void:
	get_tree().reload_current_scene()
