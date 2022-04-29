extends Sprite2D

class_name itemEntity

var myData={}
var velocity=Vector2.ZERO
var query=PhysicsShapeQueryParameters2D.new()
var lbl=Label.new()
#prepares its basic data in main thread, rest of the item system process is done on the itemManager thread
func _ready():
	top_level=true;show_on_top=true
	query.shape=GB.itemDropShape
	scale=Vector2(0.5,0.5)
	add_child(lbl)
	for item in get_tree().get_nodes_in_group("itemEntities"):
		if item.myData.item_name==myData.item_name&&item.position.distance_squared_to(position)<512:
			stack_items(item,true)
	lbl.position=Vector2(2,2)
	lbl.theme=load("gametheme.tres")
	add_to_group("itemEntities")
	updateCount()
	texture=load(myData.icon)
	GB.itemManager.allItems.push_back(self)
func _physics_process(delta):
	query.transform=transform
	velocity.y+=32*delta
	var colliding:=get_world_2d().direct_space_state.intersect_shape(query)
	if colliding:
		velocity.y=0
		check_overlap(colliding)
	position+=velocity*delta
#this is the threaded part
func check_overlapping_items():
	for item in GB.itemManager.allItems:
		if item==self:continue
		stack_items(item)

func check_overlap(overlapping):
	for object in overlapping:
		if object.collider.name=="Player":
			object.collider.inventory.store_item(myData.item_name,myData.count)
			prep_free()


func updateCount():
	lbl.text=str(myData.count)

func prep_free():
	
	GB.itemManager.allItems.erase(self)
	queue_free()

func stack_items(item,ignoreRange=false):
	if item.myData.stackSize<=item.myData.count:return
	if item.myData.item_name==myData.item_name&&(item.position.distance_squared_to(position)<32||ignoreRange):
		if myData.count+item.myData.count<=myData.stackSize:
			myData.count+=item.myData.count
			item.prep_free()
		else:
			var difference=myData.stackSize-myData.count
			myData.count=myData.stackSize
			item.myData.count-=difference
			item.updateCount()
		updateCount()


#the chunk it resides in
func getChunk():
	return GB.posToChunkAndCell(global_position)
#the data to store in the chunk files
func getStored():
	return [myData,getChunk()[1]]
