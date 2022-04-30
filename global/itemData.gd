extends Node


var allItems={}


func _ready():
	allItems=FR.loadItems()

func get_item_data(item_name):
	return allItems[item_name]
