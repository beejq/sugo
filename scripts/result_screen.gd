extends Control

@onready var minutes: Label = $timer/minute
@onready var seconds: Label = $timer/seconds
@onready var miliseconds: Label = $timer/miliseconds
@onready var tindahan: StaticBody2D = $tindahan
@onready var result_anim: AnimationPlayer = $result_anim
@onready var subtext_anim: AnimationPlayer = $subtext_anim
@onready var timer_anim: AnimationPlayer = $timer_anim
@onready var char_anim: AnimationPlayer = $char_anim


func _ready() -> void:
	result_anim.play("result_anim")
	await get_tree().create_timer(1).timeout
	subtext_anim.play("subtext_anim")
	await get_tree().create_timer(1).timeout
	timer_anim.play("timer_anim")
	await get_tree().create_timer(1).timeout
	char_anim.play("char_anim")
	

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
	
	if Gamestate.level1_fin and not Gamestate.level2_fin:
		Gamestate.level1_fin = false
		get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
	elif Gamestate.level2_fin and Gamestate.level1_fin:
		Gamestate.level2_fin = false
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")

func _on_next_level_pressed() -> void:
	Gamestate.intro_done = false
	Gamestate.ingredients_shown = false
	Gamestate.level_finished = false
	Gamestate.minigame_started = false
	Gamestate.print_once = true
	TimerManager.reset()
	TimerManager.freeze = true
	
	if Gamestate.level1_fin and not Gamestate.level2_fin:
		get_tree().change_scene_to_file("res://scenes/level_2_cutscene.tscn")
	elif Gamestate.level2_fin and Gamestate.level1_fin:
		print("CONGRATS ON FINISHING THE 2 LEVELS!")
