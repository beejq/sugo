extends Node

var level_score_container: float = 0.0

func get_minutes() -> int:
	return int(level_score_container / 60)

func get_seconds() -> int:
	return int(fmod(level_score_container, 60))

func get_msec() -> int:
	return int(fmod(level_score_container, 1) * 1000)
