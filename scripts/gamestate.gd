extends Node

var ingredients_shown : bool = false
var intro_done: bool = false
var minigame_started: bool = false
var print_once: bool = true
var level_finished: bool = false
var in_menu: bool = true

var tutorial_ingredients = ["Eggs", "Coffee", "Apple"]
var level2_ingredients = ["Pepper", "Rice", "Aji"]

var level1_fin: bool = false
var level2_fin: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back_to_menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
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
		Transition.fade_out()
		
