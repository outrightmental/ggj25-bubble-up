extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select(Global.currents_behavior)

func _on_item_selected(index:int) -> void:
	Global.set_currents_behavior(index)

