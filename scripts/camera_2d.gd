extends Camera2D

# Inside your Camera2D script
var shake_amount: float = 0.0

func shake(intensity: float = 10.0, duration: float = 0.2):
	shake_amount = intensity
	var tween = create_tween()
	tween.tween_property(self, "shake_amount", 0.0, duration)

func _process(delta: float) -> void:
	if shake_amount > 0.0:
		offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
	else:
		offset = Vector2.ZERO
