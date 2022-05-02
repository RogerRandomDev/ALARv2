extends Control


func _ready():
	call_deferred("loaded")
func loaded():
	for id in $InventoryItems.get_child_count():
		var child = $InventoryItems.get_child(id)
		child.connect("mouse_entered",self.hover_item,[child,id])
		child.connect("mouse_exited",self.stop_hover_item,[child])

var hovered_item=null
var hovered_item_point
func hover_item(item,id):
	hovered_item=item
	hovered_item_point=id
func stop_hover_item(item):
	hovered_item=null
var hovered_grab=null

func _input(_event):
	if Input.is_action_just_pressed("lmouse")&&hovered_item!=null:
		var new_data={"name":null,"count":0,"icon":null}
		if hovered_grab!=null:
			new_data=hovered_grab.myData
			
			hovered_grab.queue_free()
		grab_item()
		get_parent().player.inventory.set_slot(hovered_item_point,new_data)
		
		get_parent().update_inventory_list(hovered_item_point)
	
func grab_item():
	if hovered_item.data.texture==null:
		return
	var grabbed=dragItem.new()
	
	grabbed.myData=get_parent().player.inventory.contents[hovered_item_point].duplicate(true)
	add_child(grabbed)
	hovered_grab=grabbed

