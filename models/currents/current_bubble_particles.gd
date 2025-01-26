extends GPUParticles2D

@export var offset: Vector2 = Vector2.ZERO

const OFFSET_RANGE_MIN = -5.0
const OFFSET_RANGE_MAX = 5.0
var random_offset := Vector2.ZERO

const ANGLE_RANGE_MIN = 0.26
const ANGLE_RANGE_MAX = 0.26

const GRAVITY_NORMALIZE = 98.0

func _init() -> void:
	# Set a random offset for the bubbles
	random_offset = Vector2(randf_range(OFFSET_RANGE_MIN, OFFSET_RANGE_MAX), randf_range(OFFSET_RANGE_MIN, OFFSET_RANGE_MAX))
	one_shot = true

func init_with(pos: Vector2, direction: Vector2):
	var randomized_direction = Vector2(direction.x + randf_range(ANGLE_RANGE_MIN, ANGLE_RANGE_MAX), direction.y + randf_range(ANGLE_RANGE_MIN, ANGLE_RANGE_MAX))
	randomized_direction = randomized_direction.normalized()

	position = pos + random_offset
	process_material.gravity = Vector3(
		GRAVITY_NORMALIZE * randomized_direction.x, 
		GRAVITY_NORMALIZE * randomized_direction.y, 
		0
	)
	return self