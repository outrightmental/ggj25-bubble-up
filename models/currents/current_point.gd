class_name CurrentPoint extends Area2D

const DECAY_FACTOR = 200.0

var force_strength = 0.0

var direction := Vector2.ZERO
@onready var force_emitter = $ForceEmitter
@onready var gravity_shape = $CollisionShape2D
@onready var force_shape = $ForceEmitter/CollisionShape2D

func init_with(pos: Vector2, p_direction: Vector2):
	position = pos 
	direction = p_direction
	return self

func update_direction(p_direction: Vector2):
	direction = p_direction
	# Update force against intersecting bodies
	for body in force_emitter.get_overlapping_bodies():
		print('body')
		if body.has_method('apply_central_impulse'):
			body.apply_central_impulse(direction * force_strength)

func _ready() -> void:
	force_strength = Global.current_f_strength
	Global.connect('currents_behavior_changed', _on_currents_behavior_changed)
	Global.connect('current_param_changed', _on_current_param_changed)
	set_current_behavior(Global.currents_behavior)

func _process(delta):
	# Slowly reduce force to zero over time
	gravity += DECAY_FACTOR * delta
	gravity = min(gravity, 0.0)
	if gravity == 0.0:
		queue_free()

func _on_force_emitter_body_entered(body:Node2D) -> void:
	if body.has_method('apply_central_impulse'):
		body.apply_central_impulse(direction * force_strength)

func _on_currents_behavior_changed(value: Global.CurrentBehavior):
	set_current_behavior(value)

func set_current_behavior(value: Global.CurrentBehavior):
	match value:
		Global.CurrentBehavior.GRAVITY_FORWARD_FORCE: 
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_REPLACE
		Global.CurrentBehavior.NEAREST_POINT_FORWARD_FORCE:
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_DISABLED
		Global.CurrentBehavior.PATH_FOLLOW:
			pass
		Global.CurrentBehavior.FORWARD_FORCE_ONLY, _:
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_DISABLED

func _on_current_param_changed(param_name: String, value: float):
	match param_name:
		'current_g_strength':
			prints('changing gravity to', value)
			gravity = value
		'current_g_size':
			prints('changing gravity size to', value)
			gravity_shape.shape.radius = value
		'current_f_strength':
			prints('changing force strength to', value)
			force_strength = value
		'current_f_size':
			prints('changing force size to', value)
			force_shape.shape.radius = value
