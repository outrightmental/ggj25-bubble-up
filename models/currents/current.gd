class_name Current extends Node2D

var CurrentPointScene: PackedScene = preload('res://models/currents/current_point.tscn')

@export var lifetime := 3.0

@onready var curve = $Line2D
@onready var timer = $Timer

# var POINT_DRAW_TIMEOUT = 0.0005
# var point_draw_counter = 0

var initial_point: Vector2 = Vector2.ZERO
var previous_point_coords := Vector2.ZERO
var is_active := false

func _ready():	
	create_point(initial_point)
	timer.wait_time = lifetime
	is_active = true

func init_with(mouse_pos: Vector2):
	initial_point = mouse_pos
	previous_point_coords = mouse_pos
	return self

func create_point(pos: Vector2):
	curve.add_point(pos)

	# Calculate force
	var directional = pos - previous_point_coords
	var new_current_point = CurrentPointScene.instantiate().init_with(pos, directional)
	add_child(new_current_point)
	previous_point_coords = pos

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
		draw_point()
#		if point_draw_counter >= POINT_DRAW_TIMEOUT:
#			draw_point()
#			point_draw_counter = 0
#		else:
#			point_draw_counter += delta

func _on_timer_timeout() -> void:
	cleanup()
