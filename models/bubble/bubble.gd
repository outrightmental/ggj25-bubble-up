extends "res://models/collidable/collidable.gd"

# Constants
var _collision_merge_accel_threshold: int = 1
var _collision_split_accel_threshold: int = 4
var _split_mass_vanish_threshold: float   = 0.5
var _collision_cooldown_millis: int       = 100
var _bubble_sprite_base_size: float = 20 # bubble size at mass=1

# var _max_scale_factor: int				= 10

# Structure for holding bubble sprites of different sizes
class BubbleSprite:
	var texture: Texture
	var size: int

	func _init(_texture: Texture, _size: int):
		self.texture = _texture
		self.size = _size

# Load the bubble textures
@onready var bubble_sprites: Array[BubbleSprite] = [
	 BubbleSprite.new(preload("res://assets/bubble_20.png"), 20),
	 BubbleSprite.new(preload("res://assets/bubble_21.png"), 21),
	 BubbleSprite.new(preload("res://assets/bubble_24.png"), 24),
	 BubbleSprite.new(preload("res://assets/bubble_28.png"), 28),
	 BubbleSprite.new(preload("res://assets/bubble_32.png"), 32),
	 BubbleSprite.new(preload("res://assets/bubble_36.png"), 36),
	 BubbleSprite.new(preload("res://assets/bubble_40.png"), 40),
	 BubbleSprite.new(preload("res://assets/bubble_44.png"), 44),
	 BubbleSprite.new(preload("res://assets/bubble_48.png"), 48),
	 BubbleSprite.new(preload("res://assets/bubble_52.png"), 52),
	 BubbleSprite.new(preload("res://assets/bubble_56.png"), 56),
	 BubbleSprite.new(preload("res://assets/bubble_60.png"), 60),
	 BubbleSprite.new(preload("res://assets/bubble_64.png"), 64),
	 BubbleSprite.new(preload("res://assets/bubble_68.png"), 68),
	 BubbleSprite.new(preload("res://assets/bubble_72.png"), 72),
	 BubbleSprite.new(preload("res://assets/bubble_76.png"), 76),
	 BubbleSprite.new(preload("res://assets/bubble_80.png"), 80),
]

# Get the closest matching bubble sprite for the given size
func get_closest_bubble_sprite(size: int) -> BubbleSprite:
	var closest: BubbleSprite = bubble_sprites[0]
	for s in bubble_sprites:
		if size >= s.size:
			closest = s
		elif s.size > closest.size:
			break
	return closest

# Export the vanish particle effect resource so you can set it in the inspector
@export var vanish_particle_effect: PackedScene

# Reference to the Sprite node
@onready var sprite: Sprite2D = $Sprite2D
# Reference to the Collision node
@onready var collision: CollisionShape2D = $CollisionShape2D
# Reference to the vanish particle emitter node
@onready var vanish_particle_emitter: CPUParticles2D = $CPUParticles2D

# Store collision base size based on starting size of collision, so we know the scale factor for later
@onready var collision_base_size = collision.shape.get_rect().size.x

# Whether the bubble is still in play
var done: bool = false


# Function to merge two bubbles
func merge_into(other) -> void:
	# If the other bubble is smaller or faster, call the function to merge that into this instead
	if mass > other.mass or (mass == other.mass and linear_velocity.length() < other.linear_velocity.length()):
		other.merge_into(self)
		return

	# Lock the bubble to prevent further activity
	if done:
		return

	# Update the other bubble's mass
	other.update_mass(mass + other.mass)

	# Destroy this bubble
	queue_free()
	done = true


# Function to split a bubble: remove the current bubble and spawn two new bubbles with half the mass. Position the two
# new bubbles on opposite sides of the center of the original bubble, halfway between the center and the outside. New
# bubbles inherit the acceleration of the original bubble
func split() -> void:
	# Lock the bubble to prevent further activity
	if done:
		return

	# Calculate the new mass for the two bubbles
	var new_mass: float = mass / 2

	# If mass is below threshold, this is a vanish action, not split
	if new_mass < _split_mass_vanish_threshold:
		vanish()
		return

	# Calculate the new position for the two bubbles
	var r: float   = sprite.get_rect().size.length() / 4
	var a: float   = linear_velocity.angle()
	var v: Vector2 = Vector2(cos(a), sin(a)) * r

	# Create the new bubble 1
	var b1: Node = preload("res://models/bubble/bubble.tscn").instantiate()
	b1.position = position + v
	b1.mass = new_mass
	get_parent().call_deferred("add_child", b1)

	# Create the new bubble 2
	var b2: Node = preload("res://models/bubble/bubble.tscn").instantiate()
	b2.position = position - v
	b2.mass = new_mass
	get_parent().call_deferred("add_child", b2)

	# Destroy this bubble
	queue_free()
	done = true


# Function to vanish the bubble; air is wasted
func vanish() -> void:
	if done:
		return
	SignalBus.bubble_vanish.emit(mass)
	_destroy()


# Function to exit the bubble; score is updated
func exit() -> void:
	if done:
		return
	SignalBus.bubble_exit.emit(mass)
	_destroy()


# Function to update the scale of the bubble based on its mass
func update_mass(new_mass: float):
	mass = new_mass
	var size: int = floor(_bubble_sprite_base_size * pow(mass, 0.333))
	var bubble_sprite = get_closest_bubble_sprite(size)
	var collision_scale_factor: float = size / collision_base_size
	var sprite_scale_factor: float = max(1, size / bubble_sprite.size)
	sprite.set_deferred("texture",  bubble_sprite.texture)
	sprite.set_deferred("scale",  Vector2(sprite_scale_factor, sprite_scale_factor))
	collision.set_deferred("scale",  Vector2(collision_scale_factor, collision_scale_factor))


# Called when the bubble is instantiated
func _init():
	super._init()


# Called every frame to check if the bubble has risen to the surface
func _process(_delta) -> void:
	if global_position.y < 0:
		exit()
	elif global_position.x < -sprite.get_rect().size.x:
		exit()
	elif global_position.x > 640  + sprite.get_rect().size.x:
		exit()


# Called when the scene is added to the tree
# Load the sprite and connect the signal
func _ready():
	super._ready()
	add_to_group(Global.GROUP_BUBBLES)
	connect("body_entered", Callable(self, "_on_body_entered"))
	update_mass(mass)
	SignalBus.cull_bubbles_below.connect(_do_cull_bubbles_below)


# Called when another body enters the collision area
func _on_body_entered(other):
	if other is RigidBody2D:
		if other.is_in_group(Global.GROUP_BUBBLES):
			_on_collision_with_bubble(other)
		elif other.is_in_group(Global.GROUP_MOVABLES):
			_on_collision_with_movable(other)


# Function to handle collision with another bubble
func _on_collision_with_bubble(other) -> void:
	if min(age(), other.age()) < _collision_cooldown_millis:
		return
	var a: Vector2 = acceleration()
	var b: float   = a.length()
	if abs(b) > _collision_merge_accel_threshold:
		merge_into(other)


# Function to handle collision with a movable object
func _on_collision_with_movable(other) -> void:
	prints('hit', other.name)
	if min(age(), other.age()) < _collision_cooldown_millis:
		return
	var effective_force = other.bubble_split_factor * abs(acceleration().length())
	if  effective_force > _collision_split_accel_threshold:
		split()

# Function to destroy the bubble with an effect
func _destroy() -> void:
	# Check if a particle effect is assigned
	if vanish_particle_effect:
		# Instance the particle effect
		var particles = vanish_particle_effect.instance()
		# Add it as a child of the bubble's parent so it's positioned correctly
		get_parent().add_child(particles)
		# Set the position of the particles to the bubble's position
		particles.global_position = global_position

	# Activate the particle emitter
	vanish_particle_emitter.emitting = true

	# Hide the sprite, disable the collision shape, wait 1 second, then queue free
	sprite.hide()
	collision.set_deferred("disabled", true)
	done = true
	await get_tree().create_timer(1).timeout
	queue_free()
	
# Function to cull bubbles below a certain y position
func _do_cull_bubbles_below(y: float) -> void:
	if global_position.y > y + sprite.get_rect().size.y / 2:
		vanish()
