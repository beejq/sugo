extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

func fade_in() -> void:
	anim.play("fade_in")
	await anim.animation_finished

func fade_out() -> void:
	anim.play("fade_out")
