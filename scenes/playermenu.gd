extends CanvasLayer

@onready var player=get_parent().get_node("Player")
#runs when the player is fully built so it wont have any errors
func _ready():
	player.inventory.connect("update_slot",update_inventory_list)
	for item in player.inventory.contents:
		var item_object=InventoryItem.new()
		$InventoryItems.add_child(item_object)




func update_inventory_list(slot):
	if slot==-1:
		update_all_slots()
	else:
		var cur_item=$InventoryItems.get_child(slot)
		var item=player.inventory.contents[slot]
		var item_content=ItemSystem.get_item_data(item.name)
		cur_item.data.texture=item_content.icon
		cur_item.data.count=item.count
		cur_item.visible=true
		cur_item.update_self()
func update_all_slots():
	for itemID in player.inventory.contents.size():
		var cur_item=$InventoryItems.get_child(itemID)
		var item=player.inventory.contents[itemID]
		if item.name==null:continue
		
		var item_content=ItemSystem.get_item_data(item.name)
		cur_item.data.texture=item_content.icon
		cur_item.data.count=item.count
		cur_item.visible=true
		cur_item.update_self()
