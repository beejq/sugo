extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func resume():
	hide()
	get_tree().paused = false
	animation_player.play_backwards("blur")
	
func pause():
	if not Gamestate.showing_ingredients:
		show()
		get_tree().paused = true
		animation_player.play("blur")
	
func isEsc_pressed():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()

func _on_resume_btn_pressed() -> void:
	resume()

func _on_menu_btn_pressed() -> void:
	if not Gamestate.showing_ingredients:
		TimerManager.pause()
		TimerManager.reset()
		TimerManager.freeze = true
		
		Gamestate.ingredients_shown = false
		Gamestate.in_menu = true
		Gamestate.print_once = true
		Gamestate.minigame_started = false
		Gamestate.level1_fin = false
		Gamestate.level2_fin = false
		Gamestate.level_finished = false
		Gamestate.intro_done = false
		Engine.time_scale = 1.0
		
		Transition.fade_out()
		resume()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	isEsc_pressed()
	
func _ready() -> void:
	hide()
	animation_player.play("RESET")
