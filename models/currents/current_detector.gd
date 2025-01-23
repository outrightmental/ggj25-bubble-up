extends Area2D

var mouse_detection_active := true

var current_current: Current = null

var CurrentScene: PackedScene = preload('res://models/currents/current.tscn')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

func _on_mouse_exited() -> void:
	mouse_detection_active = false
	if current_current != null:
		complete_current()

func _on_mouse_entered() -> void:
	mouse_detection_active = true
