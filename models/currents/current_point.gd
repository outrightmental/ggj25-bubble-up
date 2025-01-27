class_name CurrentPoint extends Node2D

signal path_follower_added(follower: Node2D, path_follow_node: PathFollow2D)

const DECAY_FACTOR = 1.0

const LIFETIME = 0.7

var force_strength = 0.0
var nearest_point_influence = 0.0

var CurrentPathFollowScene: PackedScene = preload('res://models/currents/current_path_follow.tscn')

var direction := Vector2.ZERO
@onready var force_emitter = $ForceEmitter
@onready var gravity_detector = $GravityDetector
@onready var gravity_shape = $GravityDetector/CollisionShape2D
@onready var force_shape = $ForceEmitter/CollisionShape2D

var current_force_vector = Vector2.ZERO

var parent_current = null

func init_with(pos: Vector2, p_direction: Vector2, current: Current):
	position = pos 
	direction = p_direction
	current_force_vector = direction * force_strength
	parent_current = current
	return self

func update_direction(p_direction: Vector2):
	direction = p_direction
	current_force_vector = direction * force_strength
	# Update force against intersecting bodies
	for body in force_emitter.get_overlapping_bodies():
		if body.has_method('apply_central_impulse'):
			body.apply_central_impulse(current_force_vector)

func _ready() -> void:
	force_strength = Global.current_f_strength
	nearest_point_influence = Global.current_n_influence
	Global.connect('currents_behavior_changed', _on_currents_behavior_changed)
	Global.connect('current_param_changed', _on_current_param_changed)
	set_current_behavior(Global.currents_behavior)

	var lifetime_timer = get_tree().create_timer(LIFETIME)
	lifetime_timer.connect('timeout', _on_lifetime_timer_timeout)

# For performance reasons (and a bit of gameplay), do not allow the point to exist for longer than a certain time
func _on_lifetime_timer_timeout():
	queue_free()

func _process(delta):
	pass
	# Slowly reduce force to zero over time
	#if direction.length() > 0.0:
	#	var current_force_strength = current_force_vector.length()
	#	var new_force_strength = max(current_force_strength - (DECAY_FACTOR * delta), 0)
	#	current_force_vector = current_force_vector.normalized() * new_force_strength
	#	if current_force_strength <= 0.0:
	#		queue_free()
	#else:
	#	var current_force_strength = current_force_vector.length()
	#	var new_force_strength = min(current_force_strength + (DECAY_FACTOR * delta), 0)
	#	current_force_vector = current_force_vector.normalized() * new_force_strength
	#	if current_force_strength >= 0.0:
	#		queue_free()

func _on_force_emitter_body_entered(body:Node2D) -> void:
	if Global.currents_behavior == Global.CurrentBehavior.PATH_FOLLOW:
		var new_path_follow = CurrentPathFollowScene.instantiate()
		new_path_follow.set_follower(body)
		emit_signal('path_follower_added', body, new_path_follow)
	elif Global.currents_behavior == Global.CurrentBehavior.NEAREST_POINT_FORWARD_FORCE:
		if body.has_method('apply_central_impulse'):
			var vacuum_force = position - body.global_position
			body.apply_central_impulse(current_force_vector + vacuum_force * nearest_point_influence)
	else:
		if body.has_method('apply_central_impulse'):
			body.apply_central_impulse(current_force_vector)
			if body.has_method('on_current_collide'):
				body.on_current_collide(parent_current)

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
			gravity_detector.gravity = value
		'current_g_size':
			gravity_shape.shape.radius = value
		'current_f_strength':
			force_strength = value
		'current_f_size':
			force_shape.shape.radius = value
		'current_n_influence':
			nearest_point_influence = value
