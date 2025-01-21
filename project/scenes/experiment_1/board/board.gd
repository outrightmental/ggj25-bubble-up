extends RigidBody2D

var dragging: bool = false
var drag_touch_start: Vector2
var drag_pos_start: Vector2
var water_resistance: float = 1 # Simulates drag in water
var torque_factor: float = 0.5 # How much rotation is applied when dragging

@onready var collision_polygon = $CollisionPolygon2D # Cache the reference

func _ready() -> void:
	if not collision_polygon:
		push_error("CollisionPolygon2D node is missing!")
		return

func _input(event) -> void:
	if not collision_polygon:
		return # Prevent errors if the node is missing

	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed(): # Touch or mouse press
			var touch_pos: Vector2 = event.position
			if Geometry2D.is_point_in_polygon(to_local(touch_pos), collision_polygon.polygon):
				_drag_start(touch_pos)
		else: # Release
			_drag_stop()

	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			_drag(event.position)

func _drag_start(touch_pos: Vector2):
	dragging = true
	freeze = true
	lock_rotation = true
	drag_touch_start = touch_pos
	drag_pos_start = position
	
func _drag_stop():
	dragging = false
	freeze = false
	lock_rotation = false
	
func _drag(touch_pos: Vector2):
	var touch_offset: Vector2 = touch_pos - drag_touch_start
	position = drag_pos_start + touch_offset
