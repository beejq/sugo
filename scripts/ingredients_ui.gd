extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var ingredient_labels = [
	$Panel/VBoxContainer/ingredient1/label,
	$Panel/VBoxContainer/ingredient2/label,
	$Panel/VBoxContainer/ingredient3/label
]

var ingredient_images = {
	"Eggs": preload("res://assets/ui/foods/Free_pixel_food_16x16/Icons/eggs_white.png"),
	"Coffee": preload("res://assets/ui/foods/Free_pixel_food_16x16/Icons/boba_coffee.png"),
	"Apple": preload("res://assets/ui/foods/Free_pixel_food_16x16/Icons/fruit_apple.png"),
	"Pepper": preload("res://assets/ui/99_ingredients/ingredients_png/spices_png/pepper.png"),
	"Rice": preload("res://assets/ui/99_ingredients/ingredients_png/grains_png/rice.png"),
	"Aji": preload("res://assets/ui/msg.png"),
}

@onready var ingredient_images_nodes = [
	$Panel/VBoxContainer/ingredient1/TextureRect,
	$Panel/VBoxContainer/ingredient2/TextureRect2,
	$Panel/VBoxContainer/ingredient3/TextureRect3
]


var level1_ingredients = Gamestate.tutorial_ingredients
var level2_ingredients = Gamestate.level2_ingredients
func _ready() -> void:
	if not Gamestate.ingredients_shown and not Gamestate.in_menu:
		Gamestate.ingredients_shown = true
		Gamestate.showing_ingredients = true
		
		show_ingredient()
		
		await get_tree().create_timer(5.0).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(panel, "modulate:a", 0.0, 0.5)
		tween.parallel().tween_property(panel, "position:y", panel.position.y - 1000, 2.0)
		await tween.finished
		Gamestate.showing_ingredients = false
		
		panel.visible = false
		
	else:
		panel.visible = false

func show_ingredient():
	if not Gamestate.level1_fin and not Gamestate.level2_fin:
		for i in range(level1_ingredients.size()):
			_set_ingredients(level1_ingredients)
	elif Gamestate.level1_fin and not Gamestate.level2_fin:
			_set_ingredients(level2_ingredients)

			
func _set_ingredients(ingredients: Array) -> void:
	for i in range(ingredients.size()):
		# Set the label
		ingredient_labels[i].text = ingredients[i]
		
		# Set the image (null if not found in dictionary)
		ingredient_images_nodes[i].texture = ingredient_images.get(ingredients[i], null)
			
func pause():
	get_tree().paused = true
	
func unpause():
	get_tree().paused = false
