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
	for slot in max_slots:contents.push_back({"name":null,"count":0,"id":0})


func store_item(item,count:int=1):
	var fill_new=false
	var count_left=count
	var itemData=ItemSystem.get_item_data(item)
	var first_empty={}
	for slot in contents:
		if count_left<=0:continue
		if slot.name==null&&first_empty=={}:first_empty=slot;
		if slot.name==item&&slot.count<itemData.stackSize:
			var difference=itemData.stackSize-slot.count
			if count_left-difference<0:
				slot.count+=count_left
				count_left=0
			else:
				slot.count=itemData.stackSize
				count_left-=difference
	if count_left>0&&first_empty!={}:
		first_empty.name=item
		first_empty.count=count_left
	emit_signal("update_slot",-1)


func pull_item(slotID,count:int=1):
	if contents[slotID].name==null:return
	contents[slotID].values()[0]-=count
	if contents[slotID].values()[0]<=0:
		contents[slotID].name=null
		contents[slotID].count=0
		contents[slotID].id=-1
		emit_signal("empty_slot",slotID)
	
	
