extends Node

const Tiles=preload("res://gameTiles.tres")

var chunkAssemble=load("res://global/chunkBuilder.gd").new()
var playerStats=load("res://global/playerStats.gd").new()
var lighting=load("res://global/lightingSystem.gd").new()
var player=null
var moveSprite=null
var in_inventory=false
var itemDropShape=RectangleShape2D.new()
var itemManager=load("res://global/itemManager.gd").new()
#the current save file
var curSave="save0"
var defaultFont=preload("res://gameFont.tres")
var theme=load("res://gametheme.tres")
func _ready():
	itemManager._ready()
	itemDropShape.extents=Vector2(2,2)
	makeSavePath()
	chunkAssemble.chunkHolder=get_tree().current_scene
	chunkAssemble._ready()
	lighting.call_deferred('_ready')
	SaveSystem.call_deferred("loadWorld")
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
func mineCellFromChunk(chunk,cell,layer=0):
	if chunkAssemble.chunkData[chunk][layer][cell.x][cell.y]==0:return
	if chunkAssemble.loadedChunks.has(chunk):
		chunkAssemble.loadedChunks[chunk].mineTile(true,cell)
	if chunkAssemble.chunkData.has(chunk):
		chunkAssemble.chunkData[chunk][layer][cell.x][cell.y]=-1
#gets cell at given point
func getCellAtPoint(posb,layer=0):
	var pos=posToChunkAndCell(posb)
	if pos[0].x<0:pos[1].x+=1
	if !chunkAssemble.loadedChunks.has(pos[0]):return -1
	return chunkAssemble.loadedChunks[pos[0]].get_cell_source_id(layer,pos[1],false)

func getSavePath():
	return "user://saves/%s/"%curSave
func makeSavePath():
	var dir=Directory.new()
	if !dir.dir_exists(getSavePath()):
		dir.make_dir_recursive(getSavePath()+"chunks")
		dir.make_dir_recursive(getSavePath()+"data")

var time=0
func _process(delta):
	if time>=10:
		itemManager.process(delta)
		time-=10
	else:
		time+=1



func placeCellInChunk(chunk,cell,id,layer:int=0):
	if !chunkAssemble.loadedChunks.has(chunk):return
	var chunk2=chunkAssemble.loadedChunks[chunk]
	return chunk2.placeTile(!bool(layer),cell,id)
	

func load_external_texture(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_length())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex

#handles closing the game for me

var close=false
func _notification(what):
	if what == 1006:
		chunkAssemble.store_chunks()
		close=true
		chunkAssemble.semaphore.post()
		lighting.s.post()
		chunkAssemble.thread.wait_to_finish()
		lighting.thread.wait_to_finish()
		get_tree().quit()

