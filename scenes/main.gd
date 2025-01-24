extends Node2D

# Called when the scene is added to the tree
func _ready():
	get_tree().change_scene_to_file("res://scenes/experiments/experiments.tscn")
