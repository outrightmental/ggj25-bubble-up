extends "res://models/collidable/collidable_static.gd"

@export var bubble_split_factor: float = 0.38

@onready var collision_polygon = $CollisionPolygon2D # Cache the reference

func _ready() -> void:
	super._ready()
	add_to_group(Global.GROUP_MOVABLES)
	if not collision_polygon:
		push_error("CollisionPolygon2D node is missing!")
		return