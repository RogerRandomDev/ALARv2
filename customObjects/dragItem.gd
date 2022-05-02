extends Sprite2D
class_name dragItem

var myData={}

func _ready():
	if myData.icon==null:return
	texture=load(myData.icon)



func _process(delta):
	global_position=get_global_mouse_position()
