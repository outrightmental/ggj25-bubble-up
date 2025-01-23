class_name Current extends Node2D

@export var lifetime := 3.0

@onready var curve = $Line2D
@onready var timer = $Timer

var POINT_DRAW_TIMEOUT = 0.004
var point_draw_counter = 0

var initial_point: Vector2 = Vector2.ZERO
var is_active := false

func _ready():	
	curve.add_point(initial_point)
	timer.wait_time = lifetime
	is_active = true

func init_with(mouse_pos: Vector2):
	initial_point = mouse_pos
	return self

func draw_point():
	curve.add_point(get_global_mouse_position())

func complete():
	draw_point()
	is_active = false
	timer.start()

func cleanup():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		if point_draw_counter >= POINT_DRAW_TIMEOUT:
			draw_point()
			point_draw_counter = 0
		else:
			point_draw_counter += delta

func _on_timer_timeout() -> void:
	cleanup()
