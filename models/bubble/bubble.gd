extends RigidBody2D

# Unique identifier for the bubble
@export var number: int = 0

# Static variable to hold the number counter
static var _numberCounter: int = 0

# Volume of air contained in this bubble,
# measured in a totally arbitrary unit
@export var volume: float = 1.0

# Scale factor for the sprite
@export var sprite_scale_factor: float = 0.2

# Velocity last seen and delta when it was sampled
var last_velocity: Vector2 = Vector2.ZERO
var last_delta: float = 0.0

# Time created
var created_at: float = 0.0

# Load the bubble textures
@export var variant: int = 0
@onready var bubble_sprites = [
	preload("res://assets/bubble1.png"),
	preload("res://assets/bubble2.png"),
	preload("res://assets/bubble3.png"),
	preload("res://assets/bubble4.png")
]

# Reference to the Sprite node
@onready var sprite: Sprite2D = $Sprite2D

# Refernece to the Collision node
@onready var collision: CollisionShape2D = $CollisionShape2D


# Get the acceleration between the last processed frame and now
func acceleration() -> Vector2:
	return (linear_velocity - last_velocity) / last_delta;


# Function to get the age of the bubble in milliseconds 
func age() -> float:
	return Time.get_ticks_msec() - created_at

 
# Setter function to update the sprite based on variant
func set_variant(value: int):
	variant = clamp(value, 0, bubble_sprites.size() - 1)
	sprite.texture = bubble_sprites[variant]


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
	set_variant(variant)
	name = "Bubble"
	connect("body_entered", Callable(self, "_on_body_entered"))
	_update_scale()
	
	
# Called every frame
func _process(delta):
	last_velocity = linear_velocity
	last_delta = delta


# Called when another body enters the collision area
func _on_body_entered(body):
	if body is RigidBody2D and body.name.begins_with("Bubble"):
		_on_collision_with_bubble(body)


# Function to handle collision with another bubble
func _on_collision_with_bubble(other_bubble):
	if min(age(), other_bubble.age()) < Global.bubble_collision_cooldown_millis:
		return
	if _get_impulse_magnitude(other_bubble) > Global.bubble_collision_merge_accel_threshold:
		_merge_with(other_bubble)
	else:
		print("Bubble-Bubble collision #", number, " -> #", other_bubble.number)
		
		
# Function to merge two bubbles
func _merge_with(other_bubble):
	freeze= true
	var new_volume = volume + other_bubble.volume
	var new_position = (global_position * volume + other_bubble.global_position * other_bubble.volume) / new_volume
	var new_velocity = (linear_velocity * volume + other_bubble.linear_velocity * other_bubble.volume) / new_volume
	
	# Destroy the other bubble
	other_bubble.free()
	
	# Update the current bubble
	volume = new_volume
	global_position = new_position
	linear_velocity = new_velocity
	_update_scale()
	

# Function to update the scale of the bubble based on its volume
func _update_scale():
	var scale_factor = pow(volume, 0.5)
	sprite.scale = Vector2(scale_factor, scale_factor) * sprite_scale_factor
	collision.scale = Vector2(scale_factor, scale_factor)


# Function to compute the impulse between two bubbles
# Acceleration = Change in velocity / time between samples
# Last delta is just an approximation of the current frame rate
# Because it was from the last processed frame, but it will work for our purposes.
func _get_impulse_magnitude(other_bubble) -> float:
	return abs(acceleration().length())
