extends Control

func _on_level_1_btn_pressed() -> void:
	Gamestate.cutscene1_fin = true
	get_tree().change_scene_to_file("res://scenes/intro_cutscene.tscn")


func _on_level_2_btn_pressed() -> void:
	Gamestate.cutscene2_fin = true
	get_tree().change_scene_to_file("res://scenes/level_2_cutscene.tscn")


func _on_level_3_btn_pressed() -> void:
	Gamestate.cutscene3_fin = true
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	#Change to level3 cutscene


func _on_level_4_btn_pressed() -> void:
	pass # Replace with function body.


func _on_level_5_btn_pressed() -> void:
	pass # Replace with function body.


func _on_level_6_btn_pressed() -> void:
	pass # Replace with function body.
