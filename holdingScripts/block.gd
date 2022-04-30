extends Node


var holdImage=null
var place_point=Vector2.ZERO
var holding={}
var inventory_slot=-1
var player=null
func _ready():
	player=holdImage.get_parent()
	update_holding()
func update_holding(slot:int=-1):
	inventory_slot=slot
	if !holding.has("icon"):return
	holdImage.texture=load(holding.icon)
	holdImage.centered=false
	holdImage.region_enabled=true
func update(delta):
	if holding=={}:return
	if Input.is_mouse_button_pressed(1):
		var placePos=GB.posToChunkAndCell(holdImage.get_global_mouse_position())
		#returns false if the cell wasnt placed
		var placed=GB.placeCellInChunk(placePos[0],placePos[1],holding.item_id)
		if placed:
			if inventory_slot!=-1:player.inventory.pull_item(inventory_slot,1)
			holding.count-=1
			if holding.count<=0:
				holding={}
