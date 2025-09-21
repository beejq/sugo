extends Control

@onready var game_title: Label = $"game title"
@onready var text_anim: AnimationPlayer = $AnimationPlayer
@onready var selecting_button_sfx: AudioStreamPlayer2D = $selectingButtonSFX
@onready var click_sfx: AudioStreamPlayer2D = $clickSFX
@onready var bg_music: AudioStreamPlayer2D = $bgMusic

func _ready() -> void:
	bg_music.play()
	text_anim.play("title move in")
	text_anim.queue("menu selection in")
	
func _on_start_pressed() -> void:
	click_sfx.play()
	await get_tree().create_timer(0.2).timeout
	Gamestate.in_menu = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_credits_pressed() -> void:
	click_sfx.play()
	print("Change scene to credits")

func _on_quit_pressed() -> void:
	click_sfx.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func _on_start_label_mouse_entered() -> void:
	selecting_button_sfx.play()

func _on_credits_label_mouse_entered() -> void:
	selecting_button_sfx.play()

func _on_quit_label_mouse_entered() -> void:
	selecting_button_sfx.play()
