extends Node2D

@export var fish: PackedScene = null
@export var num_fish = 10
@export var school_radius = 50.0

func generate_school():
	if fish != null:
		for i in num_fish:
			generate_fish()

func generate_fish():
		var new_fish = fish.instantiate().init_with(Vector2(randf_range(-school_radius, school_radius), randf_range(-school_radius, school_radius)), true)
		add_child(new_fish)

func _ready():
	generate_school()
