extends Node
#we need to put the noise functions here
var terrainNoise0=preload("res://terrainNoise/terrainNoise0.tres")












const chunkSize=16
var curChunkCenter=Vector2i.ZERO
var loadedChunks={}
var renderDist=3
#this holds the node that will have chunks inside of it
var chunkHolder=null
#terrain modifier variables
var baseTerrainStrength=32



#thread for chunkloading
var thread=Thread.new()
var semaphore=Semaphore.new()
#prepares thread
func _ready():
	thread.start(_chunkLoad)
#does chunk loading using a separate thread to make game run more smoothly
func _chunkLoad():
	while true:
		semaphore.wait()
		var keepchunks=[]
		#loads chunks in your render distance
		for chunkX in range(-renderDist,renderDist):
			for chunkY in range(-renderDist,renderDist):
				buildChunk(curChunkCenter+Vector2i(chunkX,chunkY))
				keepchunks.push_back(curChunkCenter+Vector2i(chunkX,chunkY))
		#gets rid of unneeded chunks
		for chunk in loadedChunks.keys():
			if !keepchunks.has(chunk):
				loadedChunks[chunk].disposeChunk()
				loadedChunks.erase(chunk)
			
#the chunk builder
func buildChunk(chunkPos=null):
	if chunkPos==null:chunkPos=curChunkCenter
	if loadedChunks.has(chunkPos):return
	
	#scales up chunk position to match chunk size
	var fullChunkData=[[],[]]
	
	
	for x in chunkSize:for y in chunkSize:
		var cell=Vector2i(x,y)+chunkPos*chunkSize
		#this deals with getting all the noise values for you
		var noiseLayers=getNoiseLayers(cell)
		#use this when adding different biome types
#		var biome=getBiome()
		#currently worthless since cell rotation is gone in 4.0
		var _cellRot=0
		#id for the cell
		var cellID=0
		#the ground layer
		if(noiseLayers[0]>cell.y-64):
			cellID=-1
		if(noiseLayers[0]<cell.y-64):
			cellID=1
			if(noiseLayers[0]<cell.y-66):cellID=2
		
		#this resets cell position at the end for adding to the chunk data
		cell-=chunkPos*chunkSize
		if cellID==-1:continue
		#data is input twice for some reason, but it breaks otherwise
		var inputData=[x+y*65536,cellID,x+y*65536,cellID]
		#this one should be determined by if it is a cave or not to if it will be done
		fullChunkData[1].append_array(inputData)
		#loads the format for each cell in the tilemap array format
		fullChunkData[0].append_array(inputData)
			
	
	
	#creates the chunk object then adds it to the chunkholder on the main thread
	var chunk=Chunk2D.new()
	chunk.fillChunk(fullChunkData,chunkPos)
	chunkHolder.add_child(chunk)
	chunk.set_deferred('position',chunkPos*chunkSize*8)
	loadedChunks[chunkPos]=chunk



func getNoiseLayers(cellPos):
	return [
		round(terrainNoise0.get_noise_1d(cellPos.x)*baseTerrainStrength)
	]



