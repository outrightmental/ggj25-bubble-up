extends RigidBody2D

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

# Setter function to update the sprite based on variant
func set_variant(value: int):
	variant = clamp(value, 0, bubble_sprites.size() - 1)
	sprite.texture = bubble_sprites[variant]
	
# Called when the scene is added to the tree
func _ready():
	set_variant(variant) # Ensure the correct sprite is applied on load

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
