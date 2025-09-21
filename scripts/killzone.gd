extends Node2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
		Engine.time_scale = 0.5
		await Transition.fade_in()
		timer.start()
		#player.queue_free() # Fixes death bug (doing the death transition / respawn transition when colliding with kill zone again)

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
