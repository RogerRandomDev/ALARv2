extends Control
class_name InventoryItem
var data={"texture":null,"count":1}
var icon=Sprite2D.new()
var counter=Label.new()
var itemHolder=Node2D.new()
func _ready():
	add_child(itemHolder)
	
	minimum_size=Vector2(8,8)
	itemHolder.add_child(icon);itemHolder.add_child(counter)
	icon.centered=false
	counter.scale=Vector2(0.5,0.5)
	counter.position=Vector2(6,6)
func updateVisibility(visibility):itemHolder.visible=visibility

func update_self():
	data=data.duplicate(true)
	if data.texture!=null:icon.texture=load(data.texture)
	counter.text=str(data.count)
