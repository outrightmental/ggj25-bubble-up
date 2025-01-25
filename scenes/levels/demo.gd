extends Node2D

@onready var camera : Camera2D = $Camera2D

# Called every frame
# Find all bubble nodes and get the average position weighted by bubble mass
func _process(_delta):
	var bubbles = get_tree().get_nodes_in_group(Global.GROUP_BUBBLES)
	var total_mass = 0
	var total_position_y = 0
	# TODO consider some better algorithm here that uses sampling/interpolation/tweening instead of recomputing the average every frame 
	for bubble in bubbles:
		total_mass += bubble.mass
		total_position_y += bubble.position.y * bubble.mass
	var scroll_offset_y = -total_position_y / total_mass if total_mass > 0 else 0
	if total_mass > 0:
		camera.global_position.y = scroll_offset_y
		print("Scroll offset: " + str(camera.position.y))
