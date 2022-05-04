extends Node


var allItems={}
var allRecipes=[]

func _ready():
	allItems=FR.loadItems()
	allRecipes=FR.loadRecipes()

func get_item_data(item_name):
	return allItems[item_name].duplicate(true)


func get_raw_item_data(item_name):
	return allItems[item_name]


#loads texture for given item
func loadItemTexture(item):
	return load(allItems[item].icon)


#gets the recipe for the item
func getRecipe(item):
	for recipe in allRecipes:
		if recipe.out==item:
			return recipe
