extends Node2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var timer: Timer = $Timer
@onready var checkpoint: Area2D = $"../../checkpoint"
var justKilled: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die") and not justKilled:
		body.die()
		justKilled = true
		Engine.time_scale = 0.25
		Transition.fade_in()
		timer.start()

func _on_timer_timeout() -> void:
	if justKilled:
		player.respawn()
		Transition.fade_out()
		Engine.time_scale = 1
		player.global_position = checkpoint.checkpoint_loc
		justKilled = false
