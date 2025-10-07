extends Node2D

@onready var example_balloon: CanvasLayer = $ExampleBalloon
const INTRO_DIALOGUE = preload("res://dialogues/intro_dialogue.dialogue")
@onready var cutscene_player: AnimatedSprite2D = $cutscene_player
@onready var moving: AnimationPlayer = $Moving
@onready var jumping: AnimationPlayer = $Jumping
const INTRO_2 = preload("res://dialogues/intro_2.dialogue")

var inDialogue: bool = false
var intro2_shown: bool = false

func _ready() -> void:
	await Transition.fade_out()
	jumping.play("jumping")

	jumping.animation_finished.connect(_on_jumping_finished)
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	moving.animation_finished.connect(_on_moving_finished)

func _process(delta: float) -> void:
	if moving.is_playing():
		cutscene_player.play("walk")

func _on_jumping_finished(anim_name: String) -> void:
	if anim_name == "jumping":
		jumping.stop()
		if not inDialogue:
			inDialogue = true
			DialogueManager.show_dialogue_balloon(INTRO_DIALOGUE, "start")

func _on_dialogue_ended(resource: DialogueResource) -> void:
	if intro2_shown == false:
		inDialogue = false
		cutscene_player.flip_h = false
		moving.queue("move_in")
	elif intro2_shown:
		inDialogue = false
		await get_tree().create_timer(2.0).timeout
		Transition.fade_in()
		get_tree().change_scene_to_file("res://scenes/game.tscn")
					
func _on_moving_finished(anim_name: String) -> void:
	if anim_name == "move_in" and not intro2_shown:
		cutscene_player.stop()
		if not inDialogue:
			inDialogue = true
			intro2_shown = true
			DialogueManager.show_dialogue_balloon(INTRO_2, "start")
		
