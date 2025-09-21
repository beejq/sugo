extends Control

@onready var game_title: Label = $"game title"
@onready var text_anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	text_anim.play("title move in")
	text_anim.queue("menu selection in")
	
func _on_start_pressed() -> void:
	Gamestate.in_menu = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_credits_pressed() -> void:
	print("Change scene to credits")

func _on_quit_pressed() -> void:
	get_tree().quit()
