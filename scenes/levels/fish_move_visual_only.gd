extends Node2D

@export var movement_speed = 50.0
@export var burst_wait = 1.0
@export var deceleration = 20.0

@onready var burst_wait_timer = $BurstWaitTimer
@onready var on_screen_check = $OnScreenCheck

var is_on_screen := false

var current_velocity = movement_speed
var is_active = false

func _ready() -> void:
	on_screen_check.connect('screen_entered', _on_screen_entered)
	on_screen_check.connect('screen_exited', _on_screen_exited)

	if on_screen_check.is_on_screen():
		is_on_screen = true

	burst_wait_timer.connect('timeout', _on_burst_wait_timer_timeout)

	# Just make it wait always to keep it simple for randomness
	var wait_timer = get_tree().create_timer(randf_range(-0.1, 0.1))
	wait_timer.connect('timeout', start_swim)

func start_swim():
	is_active = true

func _on_screen_entered():
	is_on_screen = true

func _on_screen_exited():
	is_on_screen = false
	
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if !is_active or !burst_wait_timer.is_stopped() or !is_on_screen:
		return

	if scale.x > 0:
		position.x += current_velocity
	else: 
		position.x -= current_velocity
		
	if current_velocity > 0.0:
		current_velocity -= deceleration * delta
		current_velocity = clampf(current_velocity, 0, movement_speed)

	# Move fish
	if current_velocity <= 0.0:
		burst_wait_timer.wait_time = burst_wait
		burst_wait_timer.start()

func _on_burst_wait_timer_timeout():
	current_velocity = movement_speed