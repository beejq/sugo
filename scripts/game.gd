extends Node2D

@onready var timer_panel: CanvasLayer = $Timer

func _ready() -> void:
	TimerManager.start_timer_after_delay()
	Transition.fade_out()

	await get_tree().create_timer(5.0).timeout
	timer_panel.visible = true

func _process(delta: float) -> void:
	if (Gamestate.level_finished):
		pass #CHANGE SCENE TO CUTSCENE / LEVEL FINISHED
