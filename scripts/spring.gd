extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spring_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("springJumpHeight"):
		body.velocity.y = body.springJumpHeight
		animated_sprite_2d.play("spring")
		spring_sfx.play()
		
