extends Node2D

func _ready() -> void:
	Transition.fade_out()


func _on_spikes_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
