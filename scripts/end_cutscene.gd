extends Control

@onready var anim_1: AnimationPlayer = $anim1
@onready var anim_2: AnimationPlayer = $anim2
@onready var anim_3: AnimationPlayer = $anim3
const DIALOGUE_1 = preload("res://dialogues/level3_end.dialogue")
const DIALOGUE_2 = preload("res://dialogues/level3_end_2.dialogue")
const DIALOGUE_3 = preload("res://dialogues/level3_end_3.dialogue")
const  BALLOON = preload("res://scenes/balloon_bottom.tscn")

func _ready() -> void:
	anim_1.animation_finished.connect(_on_animation_end)
	anim_2.animation_finished.connect(_on_animation_end)
	anim_3.animation_finished.connect(_on_animation_end)
	
	DialogueManager.dialogue_ended.connect(_on_dia_end)

	anim_1.play("fade_in")

func _on_animation_end(anim_name : String) -> void:
	if anim_name == "fade_in":
		DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE_1, "start")
		
	if anim_name == "fade_out":
		anim_2.play("fade_in2")
		
	if anim_name == "fade_in2":
		DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE_2, "start")
		
	if anim_name == "fade_out2":
		anim_3.play("fade_in3")
		
	if anim_name == "fade_in3":
		DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE_3, "start")
		
	if anim_name == "fade_out3":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
func _on_dia_end(resource: DialogueResource) -> void:
	if resource == DIALOGUE_1:
		anim_1.play("fade_out")
	if resource == DIALOGUE_2:
		anim_2.play("fade_out2")
	if resource == DIALOGUE_3:
		anim_3.play("fade_out3")
