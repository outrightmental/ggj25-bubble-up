extends Node2D

func _on_start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/play/play.tscn")
