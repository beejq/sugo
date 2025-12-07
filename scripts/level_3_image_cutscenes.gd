extends Control

const DIALOGUE_1 = preload("res://dialogues/level3_image_cutscene_dialogues.dialogue")
const DIALOGUE_2 = preload("res://dialogues/level_3.2.dialogue")
const BALLOON = preload("res://scenes/balloon_bottom.tscn")

@onready var bottom: CanvasLayer = $Bottom
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var anim_2: AnimationPlayer = $"2nd_anim"

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_end)
	anim_2.animation_finished.connect(_on_animation_end)
	DialogueManager.dialogue_ended.connect(_on_dia_end)

	animation_player.play("fade_in1")


func _on_animation_end(anim_name : String) -> void:
	if anim_name == "fade_in1":
		DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE_1, "start")

	elif anim_name == "fade_out1":
		anim_2.play("fade_in2")

	elif anim_name == "fade_in2":
		DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE_2, "start")


func _on_dia_end(resource: DialogueResource) -> void:
	if resource == DIALOGUE_1:
		animation_player.play("fade_out1")
	if resource == DIALOGUE_2:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
