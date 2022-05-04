extends Node

var thread=Thread.new()
var s=Semaphore.new()
var lightTex=ImageTexture.new()
var img=Image.new()
var centerChunk=Vector2i.ZERO
var chunkList={}
func _ready():
	img.create(96,96,false,Image.FORMAT_RGBA8)
	GB.player.get_parent().get_node("LightingBackground").texture=lightTex
	thread.start(update_lighting)
	
	
func update_lighting():
	while true:
		s.wait()
		var rDist=3
		img.fill_rect(Rect2(0,0,96,96),Color(0,0,0,0))
		for x in range(-rDist,rDist):for y in range(-rDist,rDist):
			var chunk=chunkList[centerChunk+Vector2i(x,y)]
			for cell in chunk.get_used_cells(0):
				img.set_pixel(cell.x+x*16+48,cell.y+y*16+48,Color(0,0,0,1))
		lightTex.create_from_image(img)
		
		GB.player.get_parent().get_node("LightingBackground").global_position=(centerChunk)*128


func update_chunk_tile(tile,chunk,placed:bool=false):
	var pos=chunk-centerChunk
	img.set_pixel(tile.x+pos.x*16+48,tile.y+pos.y*16+48,Color(0,0,0,bool(placed)))
	lightTex.create_from_image(img)
