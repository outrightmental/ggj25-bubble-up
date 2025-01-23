extends RigidBody2D

# Unique identifier for the bubble
@export var number: int = 0

# Static variable to hold the number counter
static var _numberCounter: int = 0

# Volume of air contained in this bubble,
# measured in a totally arbitrary unit
@export var volume: float = 1.0

# Velocity last seen and delta when it was sampled
var last_velocity: Vector2 = Vector2.ZERO
var last_delta: float = 0.0

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


# Called when the bubble is instantiated
func _init():
	_numberCounter += 1
	number = _numberCounter
 
 
# Called when the scene is added to the tree
# Load the sprite and connect the signal
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	set_variant(variant)
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	
# Called every frame
func _process(delta):
	last_velocity = linear_velocity
	last_delta = delta


# Setter function to update the sprite based on variant
func set_variant(value: int):
	variant = clamp(value, 0, bubble_sprites.size() - 1)
	sprite.texture = bubble_sprites[variant]


# Called when another body enters the collision area
func _on_body_entered(body):
	if body is RigidBody2D and body.name == "Bubble":
		_on_collision_with_bubble(body)


# Function to handle collision with another bubble
func _on_collision_with_bubble(other_bubble):
	var impulse = _get_impulse(other_bubble).length()
	if impulse > Global.bubble_collision_merge_accel_threshold:
		print("Bubble collision #", number, " -> #", other_bubble.number, ", impulseLength=", _get_impulse(other_bubble).length())
		

# Function to compute the impulse between two bubbles
# Acceleration = Change in velocity / time between samples
# Last delta is just an approximation of the current frame rate
# Because it was from the last processed frame, but it will work for our purposes.
func _get_impulse(other_bubble):
	return (linear_velocity - last_velocity) / last_delta
