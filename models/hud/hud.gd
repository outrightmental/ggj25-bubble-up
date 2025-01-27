extends Control

@onready var bar_total: ColorRect = $"MarginContainer/VBoxContainer/HBoxContainer/Bar/Total"
@onready var bar_score: ColorRect = $"MarginContainer/VBoxContainer/HBoxContainer/Bar/Score"
@onready var bar_wasted: ColorRect = $"MarginContainer/VBoxContainer/HBoxContainer/Bar/Wasted"
@onready var menu_container: ColorRect = $"MenuContainer"
@onready var game_over_container: ColorRect = $"GameOverContainer"
@onready var menu_button: Button = $"MarginContainer/VBoxContainer/HBoxContainer/Buttons/MenuButton"
@onready var menu_resume_button: Button = $"MenuContainer/MarginContainer/VBoxContainer/ResumeButton"
@onready var menu_main_button: Button = $"MenuContainer/MarginContainer/VBoxContainer/MainButton"
@onready var menu_restart_button: Button = $"MenuContainer/MarginContainer/VBoxContainer/RestartButton"
@onready var game_over_score_text:Label = $"GameOverContainer/MarginContainer/VBoxContainer/PerfectScore"

var _total: float = 0
var _wasted: float = 0
var _score: float = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.update_wasted.connect(_update_wasted)
	SignalBus.update_score.connect(_update_score)
	SignalBus.update_total.connect(_update_total)
	SignalBus.game_over.connect(_on_game_over)
	menu_container.hide()	
	game_over_container.hide()


func _update_total(value: float) -> void:
	_total = value
	# print("[HUD] Total mass: ", mass)


func _update_wasted(value: float) -> void:
	_wasted = value
	# print("[HUD] Wasted mass: ", value)
	if value > 0 && _total > 0:
		bar_wasted.scale.x = value / _total 
	else:
		bar_wasted.scale.x = 0


func _update_score(value: int) -> void:
	_score = value
	# print("[HUD] Score: ", value)
	if value > 0 && _total > 0:
		bar_score.scale.x = value / _total
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


func _on_game_over() -> void:
	game_over_container.show()
	if _wasted == 0 and _score == _total:
		game_over_score_text.text = "Perfect Score!"
	else:
		game_over_score_text.text = str(floor(100 * _score/_total)) + "%"
	_pause()
