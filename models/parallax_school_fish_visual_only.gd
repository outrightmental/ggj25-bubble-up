extends Node2D

var fish: PackedScene = preload('res://models/parallax_school_fish_visual_only.tscn')
@export var num_fish = 10
@export var school_radius = 50.0

func generate_school():
	for i in num_fish:
		generate_fish()

func generate_fish():
		var new_fish = fish.instantiate()
		new_fish.position = Vector2(randf_range(-school_radius, school_radius), randf_range(-school_radius, school_radius))
		add_child(new_fish)

func _ready():
	generate_school()
