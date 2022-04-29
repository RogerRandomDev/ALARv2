extends Node





func get_item_data(item_name):
	var compiledData=load("res://Data/blocks/%s.tres"%item_name).get_data()
	if compiledData.icon==null:compiledData.icon="res://Textures/Tiles/%s.png"%item_name
	if compiledData.item_name=="":compiledData.item_name=item_name
	return compiledData
