extends CanvasLayer

@onready var player=get_parent().get_node("Player")

var in_inventory=false
signal inventory_opened
signal inventory_closed

#runs when the player is fully built so it wont have any errors
func _ready():
	player.inventory.connect("update_slot",update_inventory_list)
	player.inventory.connect("empty_slot",hide_inventory_item)
	for item in player.inventory.contents:
		var item_object=InventoryItem.new()
		$Inventory/inventoryBack/InventoryItems.add_child(item_object)
		
	update_inventory_menu()



#updates inventory slots
func update_inventory_list(slot):
	if slot==-1:
		update_all_slots()
	else:
		var cur_item=$Inventory/inventoryBack/InventoryItems.get_child(slot)
		var item=player.inventory.contents[slot]
		if item.name==null||item.count==0||item.icon==null:
			cur_item.updateVisibility(false)
			return
		var item_content=ItemSystem.get_item_data(item.name)
		cur_item.data.texture=item_content.icon
		cur_item.data.name=item_content.item_name
		cur_item.data.count=item.count
		cur_item.updateVisibility(true)
		if item_content.stackSize<=1:cur_item.counter.visible=false
		else:cur_item.counter.visible=true
		cur_item.update_self()

#updates all
func update_all_slots():
	for itemID in player.inventory.contents.size():
		var cur_item=$Inventory/inventoryBack/InventoryItems.get_child(itemID)
		var item=player.inventory.contents[itemID]
		if item.name==null:continue
		if item.name==null||item.count==0||item.icon==null:
			cur_item.updateVisibility(false)
			return
		var item_content=ItemSystem.get_item_data(item.name)
		cur_item.data.texture=item_content.icon
		cur_item.data.count=item.count
		cur_item.updateVisibility(true)
		cur_item.update_self()

#hides an inventory item
func hide_inventory_item(slot):
	$Inventory/inventoryBack/InventoryItems.get_child(slot).updateVisibility(false)

#updates menu for inventory
func update_inventory_menu():
	for item in player.inventory.contents.size():
		if item >5&&!in_inventory:
			$Inventory/inventoryBack/InventoryItems.get_child(item).visible=false
		else:
			$Inventory/inventoryBack/InventoryItems.get_child(item).visible=true
	var size=Vector2(4,4)+Vector2((6+int(in_inventory)*2)*12,(1+int(in_inventory)*3)*12)
	$Inventory/inventoryBack.minimum_size=size
	$Inventory/Crafting.visible=in_inventory
	$Inventory/Craftlabel.visible=in_inventory
	if in_inventory:
		process_mode=Node.PROCESS_MODE_ALWAYS
		emit_signal("inventory_opened")
	else:
		process_mode=Node.PROCESS_MODE_INHERIT
		emit_signal("inventory_closed")
	get_tree().paused=in_inventory


func _input(_event):
	if Input.is_action_just_pressed("interact"):
		in_inventory=!in_inventory
		GB.in_inventory=in_inventory
		update_inventory_menu()
