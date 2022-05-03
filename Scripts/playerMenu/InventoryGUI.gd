extends VBoxContainer


func _ready():
	call_deferred("loaded")
func loaded():
	for id in $inventoryBack/InventoryItems.get_child_count():
		var child = $inventoryBack/InventoryItems.get_child(id)
		child.connect("mouse_entered",self.hover_item,[child,id])
		child.connect("mouse_exited",self.stop_hover_item,[child])

var hovered_item=null
var hovered_item_point
func hover_item(item,id):
	hovered_item=item
	hovered_item_point=id
func stop_hover_item(_item):
	hovered_item=null
var hovered_grab=null

func _input(_event):
	if hovered_item!=null&&Input.is_action_just_pressed("lmouse"):
		var new_data={"name":null,"count":0,"icon":null}
		if hovered_grab!=null:
			new_data=hovered_grab.myData
			hovered_grab.queue_free()
			hovered_grab=null
		grab_item()
		if hovered_grab!=null&&hovered_grab.myData.name==new_data.name:
			var data=ItemSystem.get_item_data(new_data.name)
			var difference=data.stackSize-new_data.count-hovered_grab.myData.count
			var added=new_data.count+hovered_grab.myData.count
			if difference>=0:
				new_data.count=min(new_data.count+hovered_grab.myData.count,data.stackSize)
				hovered_grab.myData.count=added-new_data.count
				var gone=hovered_grab.update_text()
				if gone:
					hovered_grab=null
		get_parent().player.inventory.set_slot(hovered_item_point,new_data)
	else:if Input.is_action_just_pressed("lmouse")&&hovered_grab!=null:
		var hovered_data=hovered_grab.myData
		hovered_grab.queue_free()
		hovered_grab=null
		
func grab_item():
	if hovered_item.data.texture==null:
		return
	if hovered_grab!=null:
		hovered_grab.queue_free()
		hovered_grab=null
	var grabbed=dragItem.new()
	
	grabbed.myData=get_parent().player.inventory.contents[hovered_item_point].duplicate(true)
	add_child(grabbed)
	hovered_grab=grabbed

