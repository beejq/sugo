extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	animation_player.play("fade_in")

func _on_area_2d_body_exited(body: Node2D) -> void:
	animation_player.play("fade_out")
