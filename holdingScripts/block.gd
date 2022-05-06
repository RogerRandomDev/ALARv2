extends handBase


var place_point=Vector2.ZERO
var holding={}
var inventory_slot=-1
var player=null
func _ready():
	player=holdImage.get_parent()
	update_holding()
	super._ready()
func update_holding(slot:int=-1):
	inventory_slot=slot
	if !holding.has("icon"):return
	if holding.icon.contains("user://"):
		holdImage.texture=GB.load_external_texture(holding.icon)
	else:holdImage.texture=load(holding.icon)
	holdImage.visible=true
	holdImage.region_enabled=true
func update(_delta=0.0):
	if super.update():return
	if holding=={}:return
	var holdPos=player.get_global_mouse_position()
	holdPos-=player.global_position
	holdImage.global_position=Vector2(GB.posToCell(holdPos+player.global_position))
	if holdPos.length_squared()>576:
		holdImage.global_position=Vector2(GB.posToCell(holdPos.normalized()*24+player.global_position))
	if Input.is_mouse_button_pressed(1):
		var placePos=GB.posToChunkAndCell(holdImage.global_position)
			
		if placePos==GB.posToChunkAndCell(player.global_position):return
		#returns false if the cell wasnt placed
		var placed=GB.placeCellInChunk(placePos[0],placePos[1],holding.item_id)
		if placed:
			if inventory_slot!=-1:player.inventory.pull_item(inventory_slot,1)
			holding.count-=1
			if holding.count<=0:
				holding={}
