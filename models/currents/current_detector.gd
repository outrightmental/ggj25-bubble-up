extends Node2D

var mouse_detection_active := true

var current_current: Current = null

var CurrentScene: PackedScene = preload('res://models/currents/current.tscn')

var is_enabled := true

func _ready():
	SignalBus.toggle_current_detector.connect(_toggle_current_detector)

func _toggle_current_detector(value: bool):
	is_enabled = value

func _process(_delta: float) -> void:
	if is_enabled:
		if Input.is_action_just_pressed('touch') and mouse_detection_active:
			var mouse_pos = get_global_mouse_position()
			var current = CurrentScene.instantiate().init_with(mouse_pos)
			current_current = current
			add_child(current_current)
		if Input.is_action_just_released('touch') and current_current:
			complete_current()

func complete_current():
	current_current.complete()
	current_current = null
