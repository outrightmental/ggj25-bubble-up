extends Node2D

func _on_start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/demo.tscn")

func _on_goto_experiments() -> void:
	get_tree().change_scene_to_file("res://scenes/experiments/experiments.tscn")
