extends Resource
class_name item_data

@export var item_id:int=-1
@export var item_name:String=""
@export var custom_action:String=""
@export var stack_size:int=99
@export var item_image:String=""

func loadSelf():
	if item_image=="":item_image="res://Textures/Tiles/"+item_name+".png"
	else:item_image="res://Textures/"+item_image

func get_data():
	return {
		"stackSize":stack_size,
		"icon":item_image,
		"item_name":item_name,
		"item_id":item_id,
		"count":1
	}
