extends CharacterBody2D

var dragging: bool = false
var drag_touch_start: Vector2
var drag_pos_start: Vector2
var water_resistance: float = 1 # Simulates drag in water
var torque_factor: float = 0.5 # How much rotation is applied when dragging

@onready var collision_polygon = $CollisionPolygon2D # Cache the reference

func _ready():
	if not collision_polygon:
		push_error("CollisionPolygon2D node is missing!")
		return

func _input(event):
	if not collision_polygon:
		return # Prevent errors if the node is missing

	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed(): # Touch or mouse press
			var touch_pos = event.position
			if _is_point_in_polygon(to_local(touch_pos)):
				dragging = true
				drag_touch_start = touch_pos
				drag_pos_start = position
		else: # Release
			dragging = false

	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			var touch_pos = event.position
			var touch_offset = touch_pos - drag_touch_start		
			position = drag_pos_start + touch_offset

func _is_point_in_polygon(point: Vector2) -> bool:
	# Use Geometry to check if the point is inside the CollisionPolygon2D
	if collision_polygon.polygon:
		return Geometry2D.is_point_in_polygon(point, collision_polygon.polygon)
	return false

func wrapf(value: float, min: float, max: float) -> float:
	var range = max - min
	return ((value - min) % range + range) % range + min
