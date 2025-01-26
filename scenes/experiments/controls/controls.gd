extends Node2D

func _on_navigate_main() -> void:
	get_tree().change_scene_to_file("res://scenes/experiments/experiments.tscn")


func _on_navigate_reset() -> void:
	get_tree().reload_current_scene()
