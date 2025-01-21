extends Node2D

@onready var dropdown = $OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for behavior in Global.DragBehavior:
		dropdown.add_item(behavior)
	dropdown.select(Global.get_drag_behavior())
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# no op
	pass


func _on_navigate_main() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass


func _on_navigate_reset() -> void:
	get_tree().reload_current_scene()
	pass	


func _on_option_button_item_selected(index: int) -> void:
	Global.set_drag_behavior(index)
	pass
