extends VBoxContainer

@onready var g_strength_label = $GravityStrength
@onready var g_size_label = $GravitySize
@onready var f_size_label = $ForceSize
@onready var f_strength_label = $ForceStrength
@onready var n_point_label = $NearestPointInfluence

func get_value_label_node(label: Node):
	return label.get_node('Value')

func get_current_value(label: Node):
	return label.get_node('Slider').value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect('currents_behavior_changed', _on_currents_behavior_changed)
	Global.current_g_strength = get_current_value(g_strength_label)
	Global.current_g_size = get_current_value(g_size_label)
	Global.current_f_size = get_current_value(f_size_label)
	Global.current_f_strength = get_current_value(f_strength_label)
	Global.current_n_influence = get_current_value(n_point_label)
	update_labels()
	_on_currents_behavior_changed(Global.currents_behavior)

func update_labels():
	get_value_label_node(g_strength_label).text = str(Global.current_g_strength).pad_decimals(1)
	get_value_label_node(g_size_label).text = str(Global.current_g_size).pad_decimals(1)
	get_value_label_node(f_size_label).text = str(Global.current_f_size).pad_decimals(1)
	get_value_label_node(f_strength_label).text = str(Global.current_f_strength).pad_decimals(1)
	get_value_label_node(n_point_label).text = str(Global.current_n_influence).pad_decimals(1)

func _on_f_strength_slider_value_changed(value:float) -> void:
	Global.current_f_strength = value
	update_labels()

func _on_g_strength_slider_value_changed(value:float) -> void:
	Global.current_g_strength = value
	update_labels()

func _on_g_size_slider_value_changed(value:float) -> void:
	Global.current_g_size = value
	update_labels()

func _on_f_size_slider_value_changed(value:float) -> void:
	Global.current_f_size = value
	update_labels()

func _on_n_point_slider_value_changed(value:float) -> void:
	Global.current_n_influence = value
	update_labels()

func _on_currents_behavior_changed(value: Global.CurrentBehavior):
	match value:
		Global.CurrentBehavior.GRAVITY_FORWARD_FORCE:
			g_strength_label.visible = true
			g_size_label.visible = true
			f_size_label.visible = true
			f_strength_label.visible = true
			n_point_label.visible = false
		Global.CurrentBehavior.NEAREST_POINT_FORWARD_FORCE:
			g_strength_label.visible = false
			g_size_label.visible = false
			f_size_label.visible = true
			f_strength_label.visible = true
			n_point_label.visible = true
		Global.CurrentBehavior.FORWARD_FORCE_ONLY:
			g_strength_label.visible = false
			g_size_label.visible = false
			f_size_label.visible = true
			n_point_label.visible = false
			f_strength_label.visible = true
		Global.CurrentBehavior.PATH_FOLLOW:
			g_strength_label.visible = false
			g_size_label.visible = false
			f_size_label.visible = true
			f_strength_label.visible = true
			n_point_label.visible = false
		_:
			g_strength_label.visible = true
			g_size_label.visible = true
			f_size_label.visible = true
			f_strength_label.visible = true
			n_point_label.visible = true