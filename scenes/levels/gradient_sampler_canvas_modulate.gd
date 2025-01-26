extends CanvasGroup

@export var gradient: GradientTexture1D = null

func _ready() -> void:
	if gradient != null:
		modulate = gradient.gradient.sample(0)

func update_sample(value: float, camera_position_recompute_interval: float):
	if gradient != null:
		var sample_value = (Global.GAME_HEIGHT - value) / Global.GAME_HEIGHT
		var sample = gradient.gradient.sample(sample_value)
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(
			self,
			'modulate',
			sample,
			camera_position_recompute_interval
		).set_trans(Tween.TRANS_LINEAR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
