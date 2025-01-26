extends RigidBody2D

enum Direction {
	RIGHT = 0,
	LEFT = 1
}

@export var movement_speed = 50.0
@export var burst_wait = 1.0
@export var deceleration = 20.0
@export var starting_direction: Direction = Direction.RIGHT

@onready var burst_wait_timer = $BurstWaitTimer

var current_velocity = movement_speed
var is_influenced := false
var is_active := false
var should_randomize_movement := false

const MAX_START_OFFSET = 0.4
var start_wait_timer = null

func init_with(pos_offset: Vector2, is_movement_randomized: bool):
	position += pos_offset
	should_randomize_movement = is_movement_randomized
	return self

func start_movement():
	is_active = true

func _ready() -> void:
	if starting_direction == Direction.LEFT:
		$Sprite2D.scale = Vector2(-1, 1)
		
	burst_wait_timer.connect('timeout', _on_burst_wait_timer_timeout)
	if should_randomize_movement:
		start_wait_timer = get_tree().create_timer(randf_range(-MAX_START_OFFSET, MAX_START_OFFSET))
		start_wait_timer.connect('timeout', start_movement)
	else:
		is_active = true

func _physics_process(delta: float) -> void:
	# Don't process while waiting
	if !burst_wait_timer.is_stopped() or !is_active:
		return

	var facing_direction = (Vector2.RIGHT if starting_direction == Direction.RIGHT else Vector2.LEFT).rotated(rotation)
	linear_velocity = current_velocity * facing_direction
	if current_velocity > 0.0:
		current_velocity -= deceleration * delta
		current_velocity = clampf(current_velocity, 0, movement_speed)

	# Move fish
	if current_velocity <= 0.0:
		burst_wait_timer.wait_time = burst_wait
		burst_wait_timer.start()

func on_current_collide(_current: Current):
	is_active = false
	await get_tree().create_timer(3.0).timeout
	is_active = true

func _on_burst_wait_timer_timeout():
	current_velocity = movement_speed
