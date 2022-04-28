extends Node
#we need to put the noise functions here
var terrainNoise0=preload("res://terrainNoise/terrainNoise0.tres")






#these are used for storing chunk data and whatnot
var chunkData={}
var chunkEntities={}


###
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
				#also need to store it in a file as the chunkdata
			
#the chunk builder
func buildChunk(chunkPos=null):
	if chunkPos==null:chunkPos=curChunkCenter
	if loadedChunks.has(chunkPos):return
	#stores it as an empty chunk for helping out
	if(!chunkData.has(chunkPos)):storeEmptyChunk(chunkPos)
	
	var fullChunkData=[[],[]]
	var chunkUpdates=[]
	for x in chunkSize:for y in chunkSize:
		#builds the basic cell data
		var cell=Vector2i(x,y)+chunkPos*chunkSize
		var cellData=getCellData(cell)
		
		var cellID=cellData[0]
		
		
		#this resets cell position at the end for adding to the chunk data
		cell-=chunkPos*chunkSize
		if cellID==0&&cellData[1][1]:chunkUpdates.push_back(growTree(cell,chunkPos))
		#sets cellID if it is changed by the chunkdata already
		if chunkData[chunkPos][x][y]!=-2:cellID=chunkData[chunkPos][x][y]
		
		if cellID==-1:continue
		chunkData[chunkPos][x][y]=cellID
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
	#applies trees to the chunks
	for update in chunkUpdates:
		updateCellsForChunks(update)

#gets single cell data for each chunk
func getCellData(cell):
	#this deals with getting all the noise values for you
	var noiseLayers=getNoiseLayers(cell)
	#use this when adding different biome types
#	var biome=getBiome()
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
	return [cellID,noiseLayers]








#used for growing a tree
func growTree(cell,chunkPos):
	if !chunkData.has(chunkPos):storeEmptyChunk(chunkPos)
	var treeSize=5
	var chunkCellsUpdated={}
	var curChunk=chunkPos
	for y in treeSize:
		#default log
		var cellID=3
		#the leaves
		if y+3>treeSize:cellID=4
		cell.y-=1
		if cell.y<0:
			cell.y+=16
			curChunk.y-=1
		if !chunkCellsUpdated.has(curChunk):
			chunkCellsUpdated[curChunk]=[]
		#adds the updated cell to the update array
		chunkCellsUpdated[curChunk].push_back(cell)
		chunkCellsUpdated[curChunk].push_back(cellID)
	return chunkCellsUpdated


#updates cells in loaded chunks for when they are changed outside the main method
#pretty much worthless, but it has proven helpful sometimes
func updateCellsForChunks(chunkAndCells,layer:int=0):
	for chunk in chunkAndCells:
		storeEmptyChunk(chunk)
		if !loadedChunks.has(chunk):continue
		#every second index is the cell id
		for cell in chunkAndCells[chunk].size()/2:
			var cellPos=chunkAndCells[chunk][cell*2]
			chunkData[chunk][cellPos.x][cellPos.y]=chunkAndCells[chunk][cell*2+1]
			loadedChunks[chunk].placeTile(true,cellPos,chunkAndCells[chunk][cell*2+1])
		













#the noise layers used by world generation
func getNoiseLayers(cellPos):
	return [
		#for the ground level
		round(terrainNoise0.get_noise_1d(cellPos.x)*baseTerrainStrength),
		#for placing trees
		terrainNoise0.get_noise_1d(cellPos.x*10)>0.25
		]

func storeEmptyChunk(chunkPos):
	if chunkData.has(chunkPos):return
	chunkData[chunkPos]=[]
	for c in chunkSize:
		chunkData[chunkPos].push_back([])
		for d in chunkSize:
			chunkData[chunkPos][c].push_back(-2)


#allows me to shrink the dictionary
func updateDictionary(dic,newDic):
	for key in newDic:
		if dic.has(key):
			dic[key]+=newDic[key]
		else:
			dic[key]=newDic[key]
	return dic
