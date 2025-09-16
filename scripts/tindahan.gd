extends StaticBody2D

@onready var store_minigame: CanvasLayer = $StoreMinigame


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Time for Minigame!")
		
		store_minigame.visible = true
		
		await get_tree().create_timer(30.0).timeout
		
		store_minigame.visible = false
