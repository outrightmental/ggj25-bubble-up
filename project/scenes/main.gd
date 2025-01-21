extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# no op
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/experiment_1/experiment_1.tscn")
	pass # Replace with function body.
