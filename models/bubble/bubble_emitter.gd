extends Node2D

@export var spawn_rate: float = 1.0  # Time between bubble spawns
@export var max_bubbles: int = 10    # Maximum number of bubbles to spawn
@export var spread_x: int = 40      # Maximum horizontal distance from the emitter
@export var spread_y: int = 20       # Maximum vertical distance from the emitter
var current_bubbles: int = 0

var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1 / spawn_rate
	timer.connect("timeout", Callable(self, "_on_timer_tick"))
	timer.start()

func _on_timer_tick():
	if current_bubbles < max_bubbles:
		_spawn_bubble()
		current_bubbles += 1

# Spawn at the emitter's position +/- random spread in x and y
func _spawn_bubble():
	var new_bubble: Node = preload("res://models/bubble/bubble.tscn").instantiate()
	var spread: Vector2  = Vector2(randf_range(-spread_x, spread_x), randf_range(-spread_y, spread_y))
	new_bubble.position = spread
	self.add_child(new_bubble)
	SignalBus.bubble_spawn.emit(new_bubble.mass)
	
