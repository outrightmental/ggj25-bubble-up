extends "res://models/collidable/collidable.gd"

@export var bubble_split_factor: float = 0.38

var drag_behavior: Global.DragBehavior = Global.DragBehavior.FREEZE_AND_REPOSITION
var drag_pos_start: Vector2
var drag_touch_start: Vector2
var drag_touch_last: Vector2
var dragging: bool                     = false
var dragging_force: float              = 10 # How much force is applied when dragging

@onready var collision_polygon = $CollisionPolygon2D # Cache the reference


func _ready() -> void:
	super._ready()
	add_to_group(Global.GROUP_MOVABLES)
	dragging_force = Global.get_drag_force()
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
	drag_behavior = Global.get_drag_behavior()
	dragging_force = Global.get_drag_force()
	dragging = true
	drag_touch_start = touch_pos
	drag_touch_last = touch_pos
	drag_pos_start = position
	match drag_behavior:
		Global.DragBehavior.FREEZE_AND_REPOSITION:
			set_freeze_enabled(true)
			set_lock_rotation_enabled(true)


func _drag_stop():
	dragging = false
	set_freeze_enabled(false)
	set_lock_rotation_enabled(false)


func _drag(touch_pos: Vector2):
	match drag_behavior:
		Global.DragBehavior.FREEZE_AND_REPOSITION:
			var touch_offset_since_start: Vector2 = touch_pos - drag_touch_start
			position = drag_pos_start + touch_offset_since_start
		Global.DragBehavior.APPLY_DAMPENED_FORCE:
			var touch_offset_since_last: Vector2 = touch_pos - drag_touch_last
			var force: Vector2                   = touch_offset_since_last * dragging_force
			apply_central_impulse(force)
	drag_touch_last = touch_pos
