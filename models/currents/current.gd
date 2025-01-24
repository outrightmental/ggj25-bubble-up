class_name Current extends Node2D

var CurrentPointScene: PackedScene = preload('res://models/currents/current_point.tscn')

@export var lifetime := 3.0

@onready var line = $Line2D
@onready var timer = $Timer
@onready var path = $Path2D

enum ForceDirectionMode {
	PREV_TO_CURRENT = 0,
	CURRENT_TO_NEXT = 1
}

@export var force_direction_mode = ForceDirectionMode.CURRENT_TO_NEXT

var point_draw_timeout = 0.0
var point_draw_counter = 0

var initial_point: Vector2 = Vector2.ZERO

var previous_point_coords := Vector2.ZERO
var previous_point: CurrentPoint = null

var is_active := false

var curve: Curve2D = Curve2D.new()

func _ready():	
	Global.connect('current_param_changed', _on_current_param_changed)
	create_point(initial_point)
	timer.wait_time = lifetime
	path.curve = curve
	is_active = true
	point_draw_timeout = Global.point_freq

func init_with(mouse_pos: Vector2):
	initial_point = mouse_pos
	previous_point_coords = mouse_pos
	return self

func create_point(pos: Vector2):
	line.add_point(pos)
	curve.add_point(pos)

	# Calculate force
	if force_direction_mode == ForceDirectionMode.PREV_TO_CURRENT:
		var directional = pos - previous_point_coords
		var new_current_point = init_new_current_point(pos, directional)
		previous_point_coords = pos
		previous_point = new_current_point
	else: 
		var directional = pos - previous_point_coords
		var new_current_point = init_new_current_point(pos, Vector2.ZERO)
		if previous_point != null:
			previous_point.update_direction(directional)
		previous_point_coords = pos
		previous_point = new_current_point

func init_new_current_point(pos, directional): 
	var new_current_point = CurrentPointScene.instantiate().init_with(pos, directional, self)
	add_child(new_current_point)
	new_current_point.connect('path_follower_added', _on_path_follower_added)
	return new_current_point

func draw_point():
	create_point(get_global_mouse_position())

func complete():
	draw_point()
	is_active = false
	timer.start()

func cleanup():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		if point_draw_counter >= point_draw_timeout:
			draw_point()
			point_draw_counter = 0
		else:
			point_draw_counter += delta

func _on_timer_timeout() -> void:
	cleanup()

func _on_path_follower_added(_follower: Node2D, path_follow_node: PathFollow2D):
	path_follow_node.init_with(self)
	path.add_child(path_follow_node)

func _on_current_param_changed(param_name: String, value: float):
	if param_name == 'point_freq':
		point_draw_timeout = value

func get_object_nearest_point_offset(object: Node2D):
	var obj_pos = to_local(object.global_position)
	return curve.get_closest_offset(obj_pos)
