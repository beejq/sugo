extends Control

@onready var panel: NinePatchRect = $Panel
@onready var ingredient_labels = [
	$Panel/HBoxContainer/Ingredient1/Label,
	$Panel/HBoxContainer/Ingredient2/Label,
	$Panel/HBoxContainer/Ingredient3/Label
]

var ingredients = ["Eggs", "Coffee", "Apple"]

func _ready() -> void:
	if not Gamestate.ingredients_shown:
		Gamestate.ingredients_shown = true
		
		#pause()
		
		show_ingredient()
		
		await get_tree().create_timer(5.0).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(panel, "modulate:a", 0.0, 0.5)
		tween.parallel().tween_property(panel, "position:y", panel.position.y - 1000, 2.0)
		await tween.finished
		
		#unpause()
		
		panel.visible = false
		
		
	else:
		panel.visible = false

func show_ingredient():
	print("Show Ing")
	for i in range(ingredients.size()):
			ingredient_labels[i].text = ingredients[i]
			
func pause():
	get_tree().paused = true
	
func unpause():
	get_tree().paused = false
