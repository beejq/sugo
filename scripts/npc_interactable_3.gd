extends Area2D

@onready var animations: AnimationPlayer = $interactable_sign/AnimationPlayer
const NPC_3_DIALOGUE = preload("res://dialogues/npc3_dialogue.dialogue")
var inDialogue: bool = false
var inArea: bool = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)

func _process(delta: float) -> void:
	if inArea and Input.is_action_just_pressed("interact") and not inDialogue:
		inDialogue = true
		DialogueManager.show_dialogue_balloon(NPC_3_DIALOGUE, "start")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		animations.play("fade_in")
		inArea = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("die"):
		animations.play("fade_out")
		inArea = false

func _on_dialogue_end(resource: DialogueResource):
	inDialogue = false
