extends Node2D

@onready var timer_panel: CanvasLayer = $Timer
@onready var music: AudioStreamPlayer = $music

func _ready() -> void:
	music.play()
	
	if not Gamestate.in_menu:
		TimerManager.start_timer_after_delay()
	
	Transition.fade_out()

	await get_tree().create_timer(5.0).timeout
	timer_panel.visible = true

func _process(delta: float) -> void:
	pass
	#if (Gamestate.level_finished):
		#Gamestate.level1_fin = true
