extends RigidBody2D

# Unique identifier for the bubble
@export var number: int = 0

# Static variable to hold the number counter
static var numberCounter: int = 0

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
	numberCounter += 1
	number = numberCounter
 
# Called when the scene is added to the tree
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	set_variant(variant) # Ensure the correct sprite is applied on load
	connect("body_entered", Callable(self, "_on_body_entered"))

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
	print("Bubble collision #", number, " -> #", other_bubble.number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
