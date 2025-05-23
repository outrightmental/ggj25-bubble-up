extends Node2D

# game cannot end in less than this amount of millis
var game_over_time_threshold_millis: float = 1000

@export var camera_position_recompute_interval: float = 2.5	
@export var camera_sway_y: float = 25
@export var camera_lead_y: float = 150

@onready var camera: Camera2D = $Camera2D
@onready var timer: Timer = $Timer

# Time started
var started_at: float = 0.0


# Function to get the age of the bubble in milliseconds 
func game_clock() -> float:
	return Time.get_ticks_msec() - started_at

 
func _ready():
	started_at = Time.get_ticks_msec()
	timer.wait_time = camera_position_recompute_interval
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
	SignalBus.reset_game.emit()


func _on_timer_timeout():
	var bubbles: Array[Node] = get_tree().get_nodes_in_group(Global.GROUP_BUBBLES)
	if bubbles.size() == 0:
		if game_over_time_threshold_millis < game_clock():
			SignalBus.game_over.emit()
		return
	var total_mass: float    = 0
	var total_y: float       = 0
	for bubble in bubbles:
		var y: float = bubble.global_position.y
		var m: float = bubble.mass
		total_mass += m
		total_y += y * m
	var target_y: float = total_y / total_mass if total_mass > 0 else 0.0
	var actual_target_y: float = max(0, target_y + randf_range(-camera_sway_y, camera_sway_y) - camera_lead_y)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		camera,
		"position:y",
		actual_target_y,
		camera_position_recompute_interval
	).set_trans(Tween.TRANS_LINEAR)
	var gradient_nodes = get_tree().get_nodes_in_group('gradients')
	for gradient_node in gradient_nodes:
		if gradient_node.has_method('update_sample'):
			gradient_node.update_sample(actual_target_y, camera_position_recompute_interval)
	SignalBus.cull_bubbles_below.emit(actual_target_y + Global.cull_bubbles_below_camera_margin)


	
	
