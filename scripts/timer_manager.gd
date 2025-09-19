# TimerManager.gd
extends Node

var time: float = 0.0
var running: bool = true

func _process(delta: float) -> void:
	if running:
		await get_tree().create_timer(5.0).timeout
		time += delta

func reset() -> void:
	time = 0.0

func pause() -> void:
	running = false

func resume() -> void:
	running = true

func get_formatted() -> String:
	var minutes = int(fmod(time, 3600) / 60)
	var seconds = int(fmod(time, 60))
	var msec = int(fmod(time, 1) * 100)
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
