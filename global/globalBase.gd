extends Node

const Tiles=preload("res://gameTiles.tres")
var chunkAssemble=load("res://global/chunkBuilder.gd").new()
var playerStats=load("res://global/playerStats.gd").new()
var player=null
var moveSprite=null
func _ready():
	chunkAssemble.chunkHolder=get_tree().current_scene
	chunkAssemble._ready()
#this sets the current chunk to load, then activates the chunkloader
func loadChunk(chunkPos):
	chunkAssemble.curChunkCenter=chunkPos
	chunkAssemble.semaphore.call_deferred('post')
#converts global position to chunk position
func posToChunk(global):
	var out=Vector2i(global/chunkAssemble.chunkSize/8)
	if global.x<0:out.x-=1
	if global.y<0:out.y-=1
	return out
#converts global position to cell position
func posToCell(global):
	var cell=Vector2i(global/8)*8
	if global.x<0:cell.x-=8
	if global.y<0:cell.y-=8
	return cell
#gets cell and chunk position
func posToChunkAndCell(global):
	var chunk=posToChunk(global)
	return [chunk,posToCell(global)/8-chunk*chunkAssemble.chunkSize]

#mines cell from chunk
func mineCellFromChunk(chunk,cell):
	
	if chunkAssemble.loadedChunks.has(chunk):
		chunkAssemble.loadedChunks[chunk].mineTile(true,cell)
		chunkAssemble.chunkData[chunk][cell.x][cell.y]=-1
#gets cell at given point
func getCellAtPoint(posb):
	var pos=posToChunkAndCell(posb)
	if pos[0].x<0:pos[1].x+=1
	if !chunkAssemble.loadedChunks.has(pos[0]):return -1
	return chunkAssemble.loadedChunks[pos[0]].get_cell_source_id(0,pos[1],false)
