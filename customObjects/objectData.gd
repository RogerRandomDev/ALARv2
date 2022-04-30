extends Resource
class_name item_data

@export var item_id:int=0
@export var item_name:String=""
@export var custom_action:String=""
@export var stack_size:int=99
@export var item_image:String



func get_data():
	if item_image=="":item_image="res://Textures/Tiles/"+item_name+".png"
	return {
		"stackSize":stack_size,
		"icon":item_image,
		"item_name":item_name,
		"item_id":item_id
	}
