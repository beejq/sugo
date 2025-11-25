extends Node

var ingredients_shown : bool = false
var intro_done: bool = false
var minigame_started: bool = false
var print_once: bool = true
var level_finished: bool = false
var in_menu: bool = true
var showing_ingredients : bool = false

var tutorial_ingredients = ["Eggs", "Coffee", "Apple"]
var level2_ingredients = ["Pepper", "Rice", "Aji"]
var level3_ingredients = ["Yakult", "Cheese", "Water"]

var level1_fin: bool = false
var level2_fin: bool = false
var level3_fin: bool = false

var cutscene1_fin: bool = false
var cutscene2_fin: bool = false
var cutscene3_fin: bool = false

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("back_to_menu") and not Gamestate.showing_ingredients:
		#TimerManager.pause()
		#TimerManager.reset()
		#TimerManager.freeze = true
		#
		#Gamestate.ingredients_shown = false
		#Gamestate.in_menu = true
		#Gamestate.print_once = true
		#Gamestate.minigame_started = false
		#Gamestate.level1_fin = false
		#Gamestate.level2_fin = false
		#Gamestate.level3_fin = false
		#Gamestate.level_finished = false
		#Gamestate.intro_done = false
		#
		#Gamestate.cutscene1_fin = false
		#Gamestate.cutscene2_fin = false
		#Gamestate.cutscene3_fin = false
		#
		#Engine.time_scale = 1.0
		#
		#Transition.fade_out()
		#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	if event.is_action_pressed("back_to_menu") and not showing_ingredients:
		back_to_menu()
	
func back_to_menu():
	TimerManager.pause()
	TimerManager.reset()
	TimerManager.freeze = true
		
	ingredients_shown = false
	in_menu = true
	print_once = true
	minigame_started = false
	level1_fin = false
	level2_fin = false
	level3_fin = false
	level_finished = false
	intro_done = false
		
	cutscene1_fin = false
	cutscene2_fin = false
	cutscene3_fin = false
		
	Engine.time_scale = 1.0
		
	Transition.fade_out()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
