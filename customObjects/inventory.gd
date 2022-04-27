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
	for slot in max_slots:contents.push_back({"name":null,"count":0,"ID":0,"stackSize":1})


func store_item(item,count:int=1):
	var fill_new=false
	for slot in contents:
		pass


func pull_item(slotID,count:int=1):
	if contents[slotID].name==null:return
	contents[slotID].values()[0]-=count
	if contents[slotID].values()[0]<=0:
		contents[slotID].name=null
		emit_signal("empty_slot",slotID)
	
	
