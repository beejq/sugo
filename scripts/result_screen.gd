extends Control

@onready var minutes: Label = $timer/minute
@onready var seconds: Label = $timer/seconds
@onready var miliseconds: Label = $timer/miliseconds
@onready var tindahan: StaticBody2D = $tindahan

func _ready() -> void:
	print(ScoreManager.level_score_container)
	print(ScoreManager.get_minutes())
	print(ScoreManager.get_seconds())
	print(ScoreManager.get_msec())

func _process(delta: float) -> void:
	minutes.text = "%02d:" % ScoreManager.get_minutes()
	seconds.text = "%02d." % ScoreManager.get_seconds()
	miliseconds.text = "%03d" % ScoreManager.get_msec()

func _on_retry_pressed() -> void:
	Gamestate.intro_done = false
	Gamestate.ingredients_shown = false
	Gamestate.level_finished = false
	Gamestate.minigame_started = false
	Gamestate.print_once = true
	TimerManager.reset()
	TimerManager.freeze = true
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
