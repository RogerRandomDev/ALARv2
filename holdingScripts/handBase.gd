extends Node
class_name handBase
var holdImage=null
var background=null

func _ready():
	background=holdImage.get_parent().get_parent().get_node("playerMenu").get_child(0)
func update(_delta=0.0):
	if background==null:return
	var inside=Vector2(4,4)+Vector2((6+int(GB.in_inventory)*2)*12,(1+int(GB.in_inventory)*3)*12)
	var mpos=background.get_local_mouse_position()
	return inside.x>mpos.x&&inside.y>mpos.y
