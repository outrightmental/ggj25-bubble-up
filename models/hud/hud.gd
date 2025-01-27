extends Control

@onready var bar_total: ColorRect = $"MarginContainer/VBoxContainer/HBoxContainer/Bar/Total"
@onready var bar_score: ColorRect = $"MarginContainer/VBoxContainer/HBoxContainer/Bar/Score"
@onready var bar_wasted: ColorRect = $"MarginContainer/VBoxContainer/HBoxContainer/Bar/Wasted"
@onready var menu_container: ColorRect = $"MenuContainer"
@onready var menu_button: Button = $"MarginContainer/VBoxContainer/HBoxContainer/Buttons/MenuButton"
@onready var menu_resume_button: Button = $"MenuContainer/MarginContainer/VBoxContainer/ResumeButton"
@onready var menu_main_button: Button = $"MenuContainer/MarginContainer/VBoxContainer/MainButton"
@onready var menu_restart_button: Button = $"MenuContainer/MarginContainer/VBoxContainer/RestartButton"

var total: float = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.update_wasted.connect(_update_wasted)
	SignalBus.update_score.connect(_update_score)
	SignalBus.update_total.connect(_update_total)
	menu_container.hide()	


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


func _on_menu_open() -> void:
	menu_container.show()
	menu_button.hide()
	_pause()


func _on_menu_close() -> void:
	menu_container.hide()
	menu_button.show()
	_resume()

func _on_menu_select_resume() -> void:
	_on_menu_close()
	get_tree().reload_current_scene()


func _on_menu_select_main() -> void:
	_on_menu_close()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	
func _on_menu_select_restart() -> void:
	_on_menu_close()
	get_tree().reload_current_scene()


func _pause() -> void:
	get_tree().set_deferred("paused", true)
	
	
func _resume() -> void:
	get_tree().set_deferred("paused", false)
