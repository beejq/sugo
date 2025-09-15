extends AnimatedSprite2D

@onready var dust: AnimatedSprite2D = $"."

func _on_animation_finished() -> void:
	queue_free()
