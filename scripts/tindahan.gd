extends StaticBody2D

@onready var store_minigame: CanvasLayer = $StoreMinigame
@onready var player: CharacterBody2D = $"../Player"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not Gamestate.minigame_started:
		Gamestate.minigame_started = true
		player.canMove = false
		print("Time for Minigame!")
		
		store_minigame.visible = true
		
		store_minigame.visible = false
