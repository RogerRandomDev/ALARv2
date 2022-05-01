extends RigidDynamicBody2D

class_name itemEntity

var myData={"count":1}

var query=PhysicsShapeQueryParameters2D.new()
var lbl=Label.new()
var sprite=Sprite2D.new()
#prepares its basic data in main thread, rest of the item system process is done on the itemManager thread
func _ready():
	lock_rotation=true
	can_sleep=false
	myData=myData.duplicate(true)
	if myData.count<1:myData.count=1
	var col=CollisionShape2D.new()
	col.shape=GB.itemDropShape
	collision_layer=5
	add_child(col);add_child(sprite)
	query.shape=GB.itemDropShape.duplicate(true)
	query.shape.extents*=2
	query.collision_mask=1
	sprite.scale=Vector2(0.5,0.5)
	add_child(lbl)
	for item in get_tree().get_nodes_in_group("itemEntities"):
		if item.myData.item_name==myData.item_name&&item.position.distance_squared_to(position)<512:
			stack_items(item)
	lbl.position=Vector2(2,2)
	lbl.scale=Vector2(0.5,0.5)
	lbl.theme=load("gametheme.tres")
	add_to_group("itemEntities")
	sprite.texture=load(myData.icon)
	GB.itemManager.allItems.push_back(self)
func _physics_process(_delta):
	query.transform=transform
	var colliding:=get_world_2d().direct_space_state.intersect_shape(query)
	if colliding:
		check_overlap(colliding)
#this is the threaded part
func check_overlapping_items():
	for item in GB.itemManager.allItems:
		if item==self:continue
#		stack_items(item)

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

func stack_items(item):
	if item.myData.stackSize<=item.myData.count||item==self:return
	var itemData=item.myData
	if itemData.item_name==myData.item_name:
		myData.count+=itemData.count
		if myData.count<=myData.stackSize:
			item.prep_free()
		else:
			var difference=myData.stackSize-myData.count+item.myData.count
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
