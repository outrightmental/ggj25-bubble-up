extends RigidBody2D

# Constants
var _collision_merge_accel_threshold: int = 2000
var _collision_cooldown_millis: int       = 100
var _max_scale_factor: int                = 10

# Unique identifier for the bubble
@export var number: int = 0

# Static variable to hold the number counter
static var _numberCounter: int = 0

# Scale factor for the sprite and collision area
@export var sprite_scale_factor: float = 0.8
@export var collision_scale_factor: float = 0.5

# Velocity last seen and delta when it was sampled
var last_velocity: Vector2 = Vector2.ZERO
var last_delta: float = 0.0

# Time created
var created_at: float = 0.0

# Load the bubble textures
@onready var bubble_sprites: Array[Variant] = [
	preload("res://assets/bubble_test.png"),
#	preload("res://assets/bubble1.png"),
#	preload("res://assets/bubble2.png"),
#	preload("res://assets/bubble3.png"),
#	preload("res://assets/bubble4.png")
]

# Reference to the Sprite node
@onready var sprite: Sprite2D = $Sprite2D

# Refernece to the Collision node
@onready var collision: CollisionShape2D = $CollisionShape2D


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
	name = "Bubble #" + str(number)
 

# Called when the scene is added to the tree
# Load the sprite and connect the signal
func _ready():
	created_at = Time.get_ticks_msec()
	contact_monitor = true
	max_contacts_reported = 1
	name = "Bubble"
	connect("body_entered", Callable(self, "_on_body_entered"))
	update_mass(mass)
	
	
# Called every frame
func _process(delta):
	last_velocity = linear_velocity
	last_delta = delta


# Called when another body enters the collision area
func _on_body_entered(body):
	if body is RigidBody2D and body.name.begins_with("Bubble"):
		_on_collision_with_bubble(body)


# Function to handle collision with another bubble
func _on_collision_with_bubble(other) -> void:
	if min(age(), other.age()) < _collision_cooldown_millis:
		return
	if abs(acceleration().length()) / mass > _collision_merge_accel_threshold:
		_merge_with(other)
	else:
		# TODO collide with non-bubble
		pass
		
		
# Function to merge two bubbles
func _merge_with(other) -> void:
	# If the other bubble is larger, call the merge function on it
	if other.mass > mass:
		other._merge_with(self)
		return
	
	# Lock the other bubble to prevent further collisions
	if freeze or other.freeze:
		return
	else:
		other.freeze = true

	# Update the current bubble
	update_mass(mass + other.mass)
	
	# Destroy the other bubble
	other.queue_free()	

# Function to update the scale of the bubble based on its mass
func update_mass(new_mass: float):
	mass = new_mass
	var scale_factor: float = pow(mass, 0.333)
	sprite.scale = Vector2(scale_factor, scale_factor) * sprite_scale_factor
	collision.scale = Vector2(scale_factor, scale_factor) * collision_scale_factor
	sprite.texture = bubble_sprites[0]
	# TODO sprite.texture = bubble_sprites[clamp(int(bubble_sprites.size() * scale_factor / _max_scale_factor), 0, bubble_sprites.size() - 1)]
