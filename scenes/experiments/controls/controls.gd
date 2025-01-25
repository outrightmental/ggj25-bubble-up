extends Node2D

@onready var dropdown = $"Drag Controls/OptionButton"

@onready var slider = $"Drag Controls/VSlider"

@onready var drag_force_amount_value = $"Drag Controls/Label Drag Force Amount Value"

@onready var drag_controls = $"Drag Controls"

@export var show_drag_controls : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (show_drag_controls):
		drag_controls.show()
		for behavior in Global.DragBehavior:
			dropdown.add_item(behavior)
		dropdown.select(Global.get_drag_behavior())
		slider.set_value_no_signal(Global.get_drag_factor())
		_update_force_value()
	else:
		drag_controls.hide()	


func _on_navigate_main() -> void:
	get_tree().change_scene_to_file("res://scenes/experiments/experiments.tscn")


func _on_navigate_reset() -> void:
	get_tree().reload_current_scene()


func _on_option_button_item_selected(index: int) -> void:
	Global.set_drag_behavior(index)


func _update_force_value():
	drag_force_amount_value.set("text", str(Global.get_drag_force()))


func _on_v_slider_value_changed(value: float) -> void:
	Global.set_drag_factor(value)
	_update_force_value()
