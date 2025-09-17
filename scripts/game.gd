extends Node2D

@onready var timer_panel: CanvasLayer = $Timer

func _ready() -> void:
	Transition.fade_out()

	await get_tree().create_timer(5.0).timeout
	timer_panel.visible = true
