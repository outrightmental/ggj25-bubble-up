extends Node2D

var is_following := true

@export var movement_speed = 20.0

@onready var path_follow = $Path2D/PathFollow2D
@onready var fish = $Path2D/PathFollow2D/Fish

func _physics_process(delta: float) -> void:
# 	print(path_follow.rotation_degrees)
	path_follow.set_progress(path_follow.get_progress() + movement_speed * delta)
	if path_follow.rotation_degrees > 90 or path_follow.rotation_degrees < -90:  
		fish.scale = Vector2(1, -1)  
	else:  
		fish.scale = Vector2(1, 1) 

func on_current_collide():
	await get_tree().create_timer(3.0).timeout
	# TODO: Recover and run