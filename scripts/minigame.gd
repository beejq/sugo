extends CanvasLayer

@onready var store_minigame: CanvasLayer = $"."

func _ready() -> void:
	store_minigame.visible = false

func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and store_minigame.visible:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Left Mouse Button Pressed")
