extends Node

enum DragBehavior { FREEZE_AND_REPOSITION, APPLY_DAMPENED_FORCE }
var drag_behavior: DragBehavior = DragBehavior.FREEZE_AND_REPOSITION


func set_drag_behavior(new_behavior: DragBehavior):
	drag_behavior = new_behavior
	emit_signal("drag_behavior_changed", new_behavior)

	
func get_drag_behavior() -> DragBehavior:
	return drag_behavior