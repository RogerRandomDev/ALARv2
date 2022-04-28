extends TileMap
class_name Chunk2D
#signals that it will emit when conditions are met for them
signal chunk_loaded(chunkPos:Vector2)
signal chunk_unloaded(chunkPos:Vector2)
#the variables for the chunk
const tileSize=8
var chunkPos=Vector2i.ZERO
func _ready():
	add_layer(1)
	tile_set=GB.Tiles
#fills chunk using the tilemaps array format to make it faster
func fillChunk(chunkData:Array,myPos):
	set("layer_0/tile_data",chunkData[0])
#	set("layer_1/tile_data",chunkData[1])
	chunkPos=myPos
	emit_signal('chunk_loaded',chunkPos)



func placeTile(front:bool,tilePos:Vector2i,tileID:int=0,_tileRot:int=0):
	set_cell(int(!front),tilePos,tileID,Vector2i(0,0),0)
func mineTile(front:bool,tilePos:Vector2i):
	var cellMined=get_cell_source_id(int(!front),tilePos,false)
	var tile_name=get_tile_name(cellMined)
	print(ItemSystem.get_item_data(tile_name))
	set_cell(int(!front),tilePos,-1,Vector2i(-1,-1),-1)

func getFullData():
	var data=[[],[]]
	for l in 2:
		for x in 16:
			data[l].push_back([])
			for y in 16:
				data[l][x].push_back(get_cell_source_id(l,Vector2i(x,y),false))
	return data

func disposeChunk():
	queue_free()

func get_tile_name(cellMined):
	var source=tile_set.get_source(cellMined)
	return source.get_tile_data(Vector2i(0,0), 0).get_custom_data("name")
