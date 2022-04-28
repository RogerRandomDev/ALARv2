extends Resource
class_name item_data

@export var item_id:int=0
@export var item_name:String=""
@export var custom_action:String=""
@export var stack_size:int=99
@export var item_image:Texture2D=null

func _init():
	if item_image==null:
		item_image=load("res://Textures/Tiles/Dirt.png")
	print("a")
func get_data():
	return {
		"stackSize":stack_size,
		"icon":item_image,
		"item_name":item_name,
		"item_id":item_id
	}
