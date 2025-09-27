extends Area2D

var checkpoint_loc : Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		checkpoint_loc = body.global_position
