extends Node

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	anim.play("tutorial anims/fade in")


func _on_area_2d_body_exited(body: Node2D) -> void:
	anim.play("tutorial anims/fade out")
