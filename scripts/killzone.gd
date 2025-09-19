extends Node2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		await Transition.fade_in()
		timer.start()
		player.queue_free() # Fixes death bug (doing the death transition / respawn transition when colliding with kill zone again)

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
