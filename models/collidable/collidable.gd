extends RigidBody2D

# Constants
var _collision_cooldown_millis: int       = 100

# Unique identifier for the collidable object
@export var number: int = 0

# Static variable to hold the number counter
static var _numberCounter: int = 0

# Velocity last seen and delta when it was sampled
var last_velocity: Vector2 = Vector2.ZERO
var last_delta: float = 0.0

# Time created
var created_at: float = 0.0

# Get the acceleration between the last processed frame and now
# Acceleration = Change in velocity / time between samples
# Last delta is just an approximation of the current frame rate
# Because it was from the last processed frame, but it will work for our purposes.
func acceleration() -> Vector2:
	return (linear_velocity - last_velocity) / last_delta;


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
	contact_monitor = true
	max_contacts_reported = 1
	
	
# Called every frame
func _process(delta):
	last_velocity = linear_velocity
	last_delta = delta
