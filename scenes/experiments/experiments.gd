extends Node2D


func _on_navigate_experiment(experiment_name: String) -> void:
	get_tree().change_scene_to_file("res://scenes/experiments/" + experiment_name + ".tscn")
	
