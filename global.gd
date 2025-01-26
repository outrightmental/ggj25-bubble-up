extends Node

enum DragBehavior { FREEZE_AND_REPOSITION, APPLY_DAMPENED_FORCE }
var drag_behavior: DragBehavior = DragBehavior.APPLY_DAMPENED_FORCE
var drag_factor: float          = 0.9
var dragging_force_min: float   = 5 # How much force is applied when dragging
var dragging_force_max: float   = 200 # How much force is applied when dragging


func set_drag_behavior(value: DragBehavior):
	drag_behavior = value
	emit_signal("drag_behavior_changed", value)


func get_drag_behavior() -> DragBehavior:
	return drag_behavior


func set_drag_factor(value: float):
	drag_factor = value
	emit_signal("drag_factor_changed", value)


func get_drag_factor() -> float:
	return drag_factor


func get_drag_force() -> float:
	return lerp(dragging_force_min, dragging_force_max, drag_factor)

# Currents stuff
signal currents_behavior_changed(value: CurrentBehavior)
signal current_param_changed(name: String, value: float)

enum CurrentBehavior {
	GRAVITY_FORWARD_FORCE = 0,
	NEAREST_POINT_FORWARD_FORCE = 1,
	FORWARD_FORCE_ONLY = 2,
	PATH_FOLLOW = 3
}
var currents_behavior: CurrentBehavior = CurrentBehavior.FORWARD_FORCE_ONLY
var current_g_strength := 5.0:
	set(v):
		current_g_strength = v
		emit_signal('current_param_changed', 'current_g_strength', v)
var current_g_size := 40.0:
	set(v):
		current_g_size = v
		emit_signal('current_param_changed', 'current_g_size', v)
var current_f_strength := 16.0:
	set(v):
		current_f_strength = v
		emit_signal('current_param_changed', 'current_f_strength', v)
var current_f_size := 30.0:
	set(v):
		current_f_size = v
		emit_signal('current_param_changed', 'current_f_size', v)
var current_n_influence := 5.0:
	set(v):
		current_n_influence = v
		emit_signal('current_param_changed', 'current_n_influence', v)
var point_freq := 0.002:
	set(v):
		point_freq = v
		emit_signal('current_param_changed', 'point_freq', v)

func set_currents_behavior(value: CurrentBehavior):
	currents_behavior = value
	emit_signal('currents_behavior_changed', value)

static var GROUP_BUBBLES: String  = "bubbles"
static var GROUP_MOVABLES: String = "movables"

var GAME_HEIGHT = 4980.0