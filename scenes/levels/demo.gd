extends Node2D

@export var camera_position_recompute_interval: float = 2.5	
@export var camera_sway_y: float = 25
@export var camera_lead_y: float = 150

@onready var camera: Camera2D = $Camera2D
@onready var timer: Timer = $Timer


func _ready():
	timer.wait_time = camera_position_recompute_interval
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
	Signals.update_score(0)
	Signals.update_wasted_air_mass(0)


func _on_timer_timeout():
	var bubbles: Array[Node] = get_tree().get_nodes_in_group(Global.GROUP_BUBBLES)
	if bubbles.size() == 0:
		return
	var total_mass: float    = 0
	var total_y: float       = 0
	for bubble in bubbles:
		var y: float = bubble.global_position.y
		var m: float = bubble.mass
		total_mass += m
		total_y += y * m
	var target_y: float = total_y / total_mass if total_mass > 0 else 0.0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		camera,
		"position:y",
		target_y + randf_range(-camera_sway_y, camera_sway_y) - camera_lead_y,
		camera_position_recompute_interval
	).set_trans(Tween.TRANS_LINEAR)


	
	
