extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $StaticBody2D/AnimatedSprite2D
@onready var spring_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.isSpringing = true
		body.velocity.x = 1800
		animated_sprite_2d.play("spring")
		spring_sfx.play()
		await get_tree().create_timer(0.3).timeout
		body.isSpringing = false
