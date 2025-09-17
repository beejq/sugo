extends Node2D

@onready var timer: CanvasLayer = $Timer

func _ready() -> void:
	Transition.fade_out()
	
	await get_tree().create_timer(5.0).timeout
	
	timer.visible = true
