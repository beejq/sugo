extends Node2D

@onready var cutscene_player: AnimatedSprite2D = $cutscene_player
@onready var move_in: AnimationPlayer = $Move_in
@onready var move_out: AnimationPlayer = $Move_out

const DIALOGUE = preload("res://dialogues/level2_cutscene_dialogue.dialogue")
const DIALOGUE_EXT = preload("res://dialogues/level2_cutscene_dialogue_ext.dialogue")

var inDialogue : bool = false
var introShown : bool = false
var extShown : bool = false

func _process(delta: float) -> void:
	if move_in.is_playing():
		cutscene_player.play("walk")
	elif move_out.is_playing():
		cutscene_player.play("walk")
	else:
		cutscene_player.play("idle")

func _ready() -> void:
	Transition.fade_out()
	move_in.play("move_in")
	
	move_in.animation_finished.connect(_on_animation_finished)
	
	move_out.animation_finished.connect(_on_animation_finished)
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if introShown == false:
		inDialogue = false
		move_out.queue("move_out")
	
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "move_in":
		if not inDialogue:
			inDialogue = true
			DialogueManager.show_dialogue_balloon(DIALOGUE, "start")
	if anim_name == "move_out":
		extShown = true
		if extShown:
			inDialogue = false
			Transition.fade_in()
			print("Switch to Level 2")
			#get_tree().change_scene_to_file("res://scenes/game.tscn")
