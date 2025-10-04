extends Node2D

@onready var killzone: Area2D = $"."
@onready var spikes: Area2D = $"../spikes"
@onready var spikes_2: Area2D = $"../spikes2"
@onready var spikes_3: Area2D = $"../spikes3"
@onready var spikes_4: Area2D = $"../spikes4"
@onready var makeuniquespikes: Area2D = $"../makeuniquespikes"

@onready var player: CharacterBody2D = $"../../Player"
@onready var timer: Timer = $Timer
@onready var checkpoint: Area2D = $"../../checkpoint"
var justKilled: bool = false

func _on_body_entered(body: Node2D) -> void:
	if justKilled:
		return
	justKilled = true
	call_deferred("_handle_death", body)

func _handle_death(body: Node2D) -> void:
	if not body.has_method("die"):
		justKilled = false
		return

	body.die()
	Engine.time_scale = 0.5
	Transition.fade_in()
	_disable_hazards()
	timer.start()

func _on_timer_timeout() -> void:
	if justKilled:
		player.respawn()
		player.global_position = checkpoint.checkpoint_loc
		Transition.fade_out()
		Engine.time_scale = 1

		# 👇 short delay to prevent instant re-death
		await get_tree().create_timer(0.5).timeout  # half a second
		_enable_hazards()

		justKilled = false
		
func _enable_hazards() -> void:
	killzone.monitoring = true
	spikes.monitoring = true
	spikes_2.monitoring = true
	spikes_3.monitoring = true
	spikes_4.monitoring = true
	makeuniquespikes.monitoring = true
	
func _disable_hazards() -> void:
	killzone.monitoring = false
	spikes.monitoring = false
	spikes_2.monitoring = false
	spikes_3.monitoring = false
	spikes_4.monitoring = false
	makeuniquespikes.monitoring = false
