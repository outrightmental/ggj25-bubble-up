extends Area2D

const DECAY_FACTOR = 200.0
const CURRENT_STRENGTH = 5.0

var direction := Vector2.ZERO
@onready var force_emitted = $ForceEmitter

func init_with(pos: Vector2, p_direction: Vector2):
	position = pos 
	direction = p_direction
	return self

func _process(delta):
	# Slowly reduce force to zero over time
	gravity += DECAY_FACTOR * delta
	gravity = min(gravity, 0.0)
	if gravity == 0.0:
		queue_free()

func _on_force_emitter_body_entered(body:Node2D) -> void:
	if body.has_method('apply_central_impulse'):
		body.apply_central_impulse(direction * CURRENT_STRENGTH)
