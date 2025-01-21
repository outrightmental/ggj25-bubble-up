extends Node2D

@onready var dropdown = $OptionButton

@onready var slider = $VSlider

@onready var drag_force_amount_value = $"Label Drag Force Amount Value"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for behavior in Global.DragBehavior:
		dropdown.add_item(behavior)
	dropdown.select(Global.get_drag_behavior())
	slider.set_value_no_signal(Global.get_drag_factor())
	_update_force_value()


func _on_navigate_main() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_navigate_reset() -> void:
	get_tree().reload_current_scene()


func _on_option_button_item_selected(index: int) -> void:
	Global.set_drag_behavior(index)


func _update_force_value():
	drag_force_amount_value.set("text", str(Global.get_drag_force()))


func _on_v_slider_value_changed(value: float) -> void:
	Global.set_drag_factor(value)
	_update_force_value()
