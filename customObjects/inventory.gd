extends Node
class_name inventoryObject


signal fill_slot(slotID,Item)
signal update_slot(slotID)
signal empty_slot(slotID)


#basic variables for inventory system
var contents=[]
const max_slots=32

#still need to work on this system
func _ready():
	for slot in max_slots:contents.push_back({"name":null,"count":1,"icon":null})
	contents=contents.duplicate(true)
	call_deferred('store_item',"Drill")

func set_slot(slot,data):
	contents[slot]=data
	emit_signal("update_slot",slot)

func store_item(item,count:int=1):
	var count_left=count
	var itemData=ItemSystem.get_item_data(item)
	var first_empty=-1
	var chosen_slot=0
	for slotID in contents.size():
		var slot=contents[slotID]
		if count_left<=0:continue
		if slot.name==null&&first_empty==-1:first_empty=slotID;
		if slot.name==item&&slot.count<itemData.stackSize:
			var difference=itemData.stackSize-slot.count
			if count_left-difference<0:
				slot.count+=count_left
				count_left=0
			else:
				slot.count=itemData.stackSize
				count_left-=difference
			emit_signal("update_slot",slotID)
	if count_left>0&&first_empty!=-1:
		chosen_slot=first_empty
		first_empty=contents[first_empty]
		first_empty.name=item
		first_empty.count=count_left
		first_empty.icon=itemData.icon
		emit_signal("update_slot",chosen_slot)

func pull_item(slotID,count:int=1):
	if contents[slotID].name==null:return
	contents[slotID].count-=count
	if contents[slotID].count<=0:
		contents[slotID].name=null
		contents[slotID].count=0
		emit_signal("empty_slot",slotID)
	else:
		emit_signal("update_slot",slotID)
	
