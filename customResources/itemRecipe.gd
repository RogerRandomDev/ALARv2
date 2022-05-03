extends Resource
class_name Recipe

@export var output_name:String
#@export var input_list:Dictionary,Vector2={}
@export var input_list:PackedStringArray
@export var input_count:PackedInt32Array


func get_recipe():
	var input={}
	for item in input_list.size():
		input[input_list[item]]=input_count[item]
	var output={"out":output_name,"input":input}
	return output
