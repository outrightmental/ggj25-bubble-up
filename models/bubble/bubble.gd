extends "res://models/collidable/collidable.gd"

# Constants
var _collision_merge_accel_threshold: int = 2000
var _collision_split_accel_threshold: int = 2000
var _max_scale_factor: int                = 10

# Scale factor for the sprite and collision area
@export var sprite_scale_factor: float = 0.8
@export var collision_scale_factor: float = 0.5

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
	super._init()
	name = "Bubble #" + str(number)
 

# Called when the scene is added to the tree
# Load the sprite and connect the signal
func _ready():
	super._ready()
	connect("body_entered", Callable(self, "_on_body_entered"))
	update_mass(mass)
	
	
# Called every frame
func _process(delta):
	last_velocity = linear_velocity
	last_delta = delta


# Called when another body enters the collision area
func _on_body_entered(other):
	if other is RigidBody2D:
		if other.name.begins_with("Bubble"):
			_on_collision_with_bubble(other)
			return
		if other.name.begins_with("Movable"):
			_on_collision_with_movable(other)
			return


# Function to handle collision with another bubble
func _on_collision_with_bubble(other) -> void:
	if min(age(), other.age()) < _collision_cooldown_millis:
		return
	if abs(acceleration().length()) / mass > _collision_merge_accel_threshold:
		_merge_into(other)


# Function to handle collision with a movable object
func _on_collision_with_movable(other) -> void:
	if min(age(), other.age()) < _collision_cooldown_millis:
		return
	if abs(acceleration().length()) / mass > _collision_split_accel_threshold:
		_split()
		
		
# Function to merge two bubbles
func _merge_into(other) -> void:
	# If the other bubble is smaller or faster, call the function to merge that into this instead
	if mass > other.mass:
		other._merge_into(self)
		return
	
	# Lock the other bubble to prevent further collisions
	if freeze or other.freeze:
		return
	else:
		freeze = true

	# Update the other bubble's mass
	other.update_mass(mass + other.mass)
	
	# Destroy this bubble
	queue_free()	
	

# Function to split a bubble: remove the current bubble and spawn two new bubbles with half the mass. Position the two
# new bubbles on opposite sides of the center of the original bubble, halfway between the center and the outside. New
# bubbles inherit the acceleration of the original bubble
func _split() -> void:
	# Lock the other bubble to prevent further collisions
	if freeze:
		return
	else:
		freeze = true

	# Calculate the new mass for the two bubbles
	var new_mass: float = mass / 2

	# Calculate the new position for the two bubbles
	var r: float = sprite.get_rect().size.length() / 4
	var a: float = linear_velocity.angle()
	var v: Vector2 = Vector2(cos(a), sin(a)) * r

	# Create the new bubble 1
	var b1 = preload("res://models/bubble/bubble.tscn").instantiate()
	b1.position = position + v
	b1.mass = new_mass
	get_parent().add_child(b1)
	
	# Create the new bubble 2
	var b2 = preload("res://models/bubble/bubble.tscn").instantiate()
	b2.position = position - v
	b2.mass = new_mass
	get_parent().add_child(b2)
	
	# Destroy this bubble
	queue_free()
	

# Function to update the scale of the bubble based on its mass
func update_mass(new_mass: float):
	mass = new_mass
	var scale_factor: float = pow(mass, 0.333)
	sprite.scale = Vector2(scale_factor, scale_factor) * sprite_scale_factor
	collision.scale = Vector2(scale_factor, scale_factor) * collision_scale_factor
	sprite.texture = bubble_sprites[0]
	# TODO sprite.texture = bubble_sprites[clamp(int(bubble_sprites.size() * scale_factor / _max_scale_factor), 0, bubble_sprites.size() - 1)]
