extends TileMap
class_name Chunk2D
#signals that it will emit when conditions are met for them
signal chunk_loaded(chunkPos:Vector2)
signal chunk_unloaded(chunkPos:Vector2)
#the variables for the chunk
const tileSize=8
var chunkPos=Vector2i.ZERO
func _ready():tile_set=GB.Tiles
#fills chunk using the tilemaps array format to make it faster
func fillChunk(chunkData:Array,myPos):
#	set("layer_0/tile_data",chunkData[0])
	set("layer_1/tile_data",chunkData[1])
	set_cell(0,Vector2i(1,1),0,Vector2i(0,0),0)
	print(get("layer_0/tile_data"))
	chunkPos=myPos
	emit_signal('chunk_loaded',chunkPos)



func placeTile(front:bool,tilePos:Vector2i,tileID:int,tileRot:int=0):
	set_cell(int(!front),tilePos-chunkPos,tileID,Vector2i(0,0),tileID)
