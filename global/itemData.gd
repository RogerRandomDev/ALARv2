extends Node


var allItems={}
var allRecipes=[]

func _ready():
	allItems=FR.loadItems()
	allRecipes=FR.loadRecipes()
	FR.loadTexturePack("a")

func get_item_data(item_name):
	return allItems[item_name].duplicate(true)


func get_raw_item_data(item_name):
	return allItems[item_name]


#loads texture for given item
func loadItemTexture(item):
	var texture=null
	if allItems[item].icon.contains("user://"):
		texture=GB.load_external_texture(allItems[item].icon)
	else:texture=load(allItems[item].icon)
	return texture


#gets the recipe for the item
func getRecipe(item):
	for recipe in allRecipes:
		if recipe.out==item:
			return recipe
