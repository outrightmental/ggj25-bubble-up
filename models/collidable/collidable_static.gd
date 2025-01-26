extends StaticBody2D

# Unique identifier for the collidable object
@export var number: int = 0

# Static variable to hold the number counter
static var _numberCounter: int = 0

# Velocity last seen and delta when it was sampled
var last_velocity: Vector2 = Vector2.ZERO

# Time created
var created_at: float = 0.0

func acceleration():
	return Vector2.ZERO
	
# Function to get the age of the bubble in milliseconds 
func age() -> float:
	return Time.get_ticks_msec() - created_at

 
# Called when the bubble is instantiated
func _init():
	_numberCounter += 1
	number = _numberCounter

# Called when the scene is added to the tree
# Load the sprite and connect the signal
func _ready():
	created_at = Time.get_ticks_msec()
