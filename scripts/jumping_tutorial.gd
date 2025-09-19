extends Node

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	animation_player.play("fade in")
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	animation_player.play("fade out")
