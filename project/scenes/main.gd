extends Node2D

func _on_navigate_experiment_1() -> void:
	_on_navigate_experiment(1)


func _on_navigate_experiment_2() -> void:
	_on_navigate_experiment(2)


func _on_navigate_experiment(experiment_number: int) -> void:
	get_tree().change_scene_to_file("res://scenes/experiment_" + str(experiment_number) + "/experiment_" + str(experiment_number) + ".tscn")
	
