extends Node2D

@onready var bar_total: ColorRect = $"Bar/Total"
@onready var bar_score: ColorRect = $"Bar/Score"
@onready var bar_wasted: ColorRect = $"Bar/Wasted"

var total: float = 0

func _ready() -> void:
	SignalBus.update_wasted.connect(_update_wasted)
	SignalBus.update_score.connect(_update_score)
	SignalBus.update_total.connect(_update_total)


func _update_total(mass: float) -> void:
	# print("[HUD] Total mass: ", mass)
	total = mass


func _update_wasted(value: float) -> void:
	# print("[HUD] Wasted mass: ", value)
	if value > 0 && total > 0:
		bar_wasted.scale.x = value / total 
	else:
		bar_wasted.scale.x = 0


func _update_score(value: int) -> void:
	# print("[HUD] Score: ", value)
	if value > 0 && total > 0:
		bar_score.scale.x = value / total
	else:
		bar_score.scale.x = 0


func _on_navigate_main() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_navigate_reset() -> void:
	get_tree().reload_current_scene()
