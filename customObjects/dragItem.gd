extends Sprite2D
class_name dragItem

var myData={}
var txt=Label.new()
func _ready():
	if myData.icon==null:return
	if myData.icon.contains("user://"):
		texture=GB.load_external_texture(myData.icon)
	else:texture=load(myData.icon)
	if myData.count>1:
		txt.text=str(myData.count)
		add_child(txt)
		txt.scale=Vector2(0.5,0.5)
		txt.theme=GB.theme
		txt.position=Vector2(2,2)

func update_text():
	txt.text=str(myData.count)
	if myData.count<=0:
		self.queue_free()
		return false
	return true

func _process(_delta):
	global_position=get_global_mouse_position()
