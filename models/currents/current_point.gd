class_name CurrentPoint extends Node2D

signal path_follower_added(follower: Node2D, path_follow_node: PathFollow2D)

const DECAY_FACTOR = 200.0

var force_strength = 0.0
var nearest_point_influence = 0.0

var CurrentPathFollowScene: PackedScene = preload('res://models/currents/current_path_follow.tscn')

var direction := Vector2.ZERO
@onready var force_emitter = $ForceEmitter
@onready var gravity_detector = $GravityDetector
@onready var gravity_shape = $GravityDetector/CollisionShape2D
@onready var force_shape = $ForceEmitter/CollisionShape2D

var parent_current = null

func init_with(pos: Vector2, p_direction: Vector2, current: Current):
	position = pos 
	direction = p_direction
	parent_current = current
	return self

func update_direction(p_direction: Vector2):
	direction = p_direction
	# Update force against intersecting bodies
	for body in force_emitter.get_overlapping_bodies():
		if body.has_method('apply_central_impulse'):
			body.apply_central_impulse(direction * force_strength)

func _ready() -> void:
	force_strength = Global.current_f_strength
	nearest_point_influence = Global.current_n_influence
	Global.connect('currents_behavior_changed', _on_currents_behavior_changed)
	Global.connect('current_param_changed', _on_current_param_changed)
	set_current_behavior(Global.currents_behavior)

func _process(delta):
	# Slowly reduce force to zero over time
	gravity_detector.gravity += DECAY_FACTOR * delta
	gravity_detector.gravity = min(gravity_detector.gravity, 0.0)
	if gravity_detector.gravity == 0.0:
		queue_free()

func _on_force_emitter_body_entered(body:Node2D) -> void:
	if Global.currents_behavior == Global.CurrentBehavior.PATH_FOLLOW:
		var new_path_follow = CurrentPathFollowScene.instantiate()
		new_path_follow.set_follower(body)
		emit_signal('path_follower_added', body, new_path_follow)
	elif Global.currents_behavior == Global.CurrentBehavior.NEAREST_POINT_FORWARD_FORCE:
		if body.has_method('apply_central_impulse'):
			var vacuum_force = position - body.global_position
			body.apply_central_impulse(direction * force_strength + vacuum_force * nearest_point_influence)
	else:
		if body.has_method('apply_central_impulse'):
			body.apply_central_impulse(direction * force_strength)

func _on_currents_behavior_changed(value: Global.CurrentBehavior):
	set_current_behavior(value)

func set_current_behavior(value: Global.CurrentBehavior):
	match value:
		Global.CurrentBehavior.GRAVITY_FORWARD_FORCE: 
			gravity_detector.gravity_space_override = Area2D.SpaceOverride.SPACE_OVERRIDE_REPLACE
		Global.CurrentBehavior.NEAREST_POINT_FORWARD_FORCE:
			gravity_detector.gravity_space_override = Area2D.SpaceOverride.SPACE_OVERRIDE_DISABLED
		Global.CurrentBehavior.PATH_FOLLOW:
			gravity_detector.gravity_space_override = Area2D.SpaceOverride.SPACE_OVERRIDE_DISABLED
		Global.CurrentBehavior.FORWARD_FORCE_ONLY, _:
			gravity_detector.gravity_space_override = Area2D.SpaceOverride.SPACE_OVERRIDE_DISABLED

func _on_current_param_changed(param_name: String, value: float):
	match param_name:
		'current_g_strength':
			prints('changing gravity to', value)
			gravity_detector.gravity = value
		'current_g_size':
			prints('changing gravity size to', value)
			gravity_shape.shape.radius = value
		'current_f_strength':
			prints('changing force strength to', value)
			force_strength = value
		'current_f_size':
			prints('changing force size to', value)
			force_shape.shape.radius = value
		'current_n_influence':
			prints('changing nearest point influence to', value)
			nearest_point_influence = value

