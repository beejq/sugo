extends CanvasLayer

@onready var store_minigame: CanvasLayer = $"."
@onready var ing_1: PanelContainer = $Panel/GridContainer/ing1
@onready var ing_2: PanelContainer = $Panel/GridContainer/ing2
@onready var ing_3: PanelContainer = $Panel/GridContainer/ing3
@onready var ing_4: PanelContainer = $Panel/GridContainer/ing4
@onready var ing_5: PanelContainer = $Panel/GridContainer/ing5
@onready var ing_6: PanelContainer = $Panel/GridContainer/ing6
@onready var grid_container: GridContainer = $Panel/GridContainer
@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/GridContainer/ing1/MarginContainer/VBoxContainer/Label
@onready var selecting_button_sfx: AudioStreamPlayer2D = $selectingButtonSFX
@onready var click_sfx: AudioStreamPlayer2D = $clickSFX

@onready var label1: Label = $Panel/GridContainer/ing1/MarginContainer/VBoxContainer/Label
@onready var label2: Label = $Panel/GridContainer/ing2/MarginContainer/VBoxContainer/Label
@onready var label3: Label = $Panel/GridContainer/ing3/MarginContainer/VBoxContainer/Label
@onready var label4: Label = $Panel/GridContainer/ing4/MarginContainer/VBoxContainer/Label
@onready var label5: Label = $Panel/GridContainer/ing5/MarginContainer/VBoxContainer/Label
@onready var label6: Label = $Panel/GridContainer/ing6/MarginContainer/VBoxContainer/Label

var player_clicks: int = 0

var correct_answers = Gamestate.tutorial_ingredients
var player_answers = []

func _ready() -> void:
	store_minigame.visible = false

func _process(delta: float) -> void:
	var sorted_player = player_answers.duplicate()
	sorted_player.sort()
	
	var sorted_correct = correct_answers.duplicate()
	sorted_correct.sort()
	
	if player_clicks == 3:
		if sorted_player == sorted_correct:
			if Gamestate.print_once:
				print("You Win!")
				Gamestate.print_once = false
				Gamestate.level_finished = true
		else:
			if Gamestate.print_once:
				print("You Lose!")
				Gamestate.print_once = false

func _on_button_1_pressed() -> void:
	if player_clicks < 3:
		player_answers.append(label1.text)
		player_clicks += 1
		click_sfx.play()

func _on_button_2_pressed() -> void:
	if player_clicks < 3:
		player_answers.append(label2.text)
		player_clicks += 1
		click_sfx.play()

func _on_button_3_pressed() -> void:
	if player_clicks < 3:
		player_answers.append(label3.text)
		player_clicks += 1
		click_sfx.play()

func _on_button_4_pressed() -> void:
	if player_clicks < 3:
		player_answers.append(label4.text)
		player_clicks += 1
		click_sfx.play()

func _on_button_5_pressed() -> void:
	if player_clicks < 3:
		player_answers.append(label5.text)
		player_clicks += 1
		click_sfx.play()

func _on_button_6_pressed() -> void:
	if player_clicks < 3:
		player_answers.append(label6.text)
		player_clicks += 1
		click_sfx.play()
