extends Resource
class_name item_data

@export var item_id:int=-1
@export var item_name:String=""
@export var custom_action:String=""
@export var stack_size:int=99
@export var item_image:String=""
@export var drop_item:String=""
@export var drop_count:int=1
func loadSelf():
	if item_image=="":item_image="res://Textures/Tiles/"+item_name+".png"
	else:item_image="res://Textures/"+item_image

func get_data():
	return {
		"stackSize":stack_size,
		"icon":item_image,
		"item_name":item_name,
		"item_id":item_id,
		"item_drop":drop_item,
		"item_drop_count":drop_count,
		"count":1
	}
