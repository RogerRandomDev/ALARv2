extends Node


var allItems={}
var allRecipes={}

func _ready():
	allItems=FR.loadItems()

func get_item_data(item_name):
	return allItems[item_name].duplicate(true)


func get_raw_item_data(item_name):
	return allItems[item_name]
