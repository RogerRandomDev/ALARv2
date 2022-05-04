extends Node
#we need to put the noise functions here
var terrainNoise0=preload("res://terrainNoise/terrainNoise0.tres")
var caveNoise0=preload("res://terrainNoise/caveNoise0.tres")
<<<<<<< HEAD
var caveNoise1=preload("res://terrainNoise/caveNoise0.tres").duplicate(true)
var caveDepthNoise=preload("res://terrainNoise/caveDepth0.tres")
=======
var caveNoise1=preload("res://terrainNoise/caveNoise1.tres")
var oreNoise0=preload("res://terrainNoise/oreNoise0.tres")

>>>>>>> 410affe50b52150f84235c01553f82cd2690243c



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
	caveNoise1.seed+=1
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
				
		#removes items that are unneedeed
		for item in GB.itemManager.allItems:
			var chunk=item.getChunk()
			if !keepchunks.has(chunk[0]):
				chunkEntities[chunk[0]].push_back(item.getStored())
				item.prep_free()
		#gets rid of unneeded chunks
		for chunk in loadedChunks.keys():
			if !keepchunks.has(chunk):
				var sChunk=loadedChunks[chunk]
				SaveSystem.saveChunk(chunk,sChunk.getFullData(),chunkEntities[chunk])
				sChunk.disposeChunk()
				loadedChunks.erase(chunk)
				chunkData.erase(chunk)
				if chunkEntities.has(chunk):
					chunkEntities.erase(chunk)
				#also need to store it in a file as the chunkdata
		#this deals with entities outside chunks
		for entity in chunkEntities:
			if !keepchunks.has(entity):
				SaveSystem.insertEntitiesToChunk(entity,chunkEntities[entity])
		GB.lighting.centerChunk=curChunkCenter
		GB.lighting.chunkList=loadedChunks
		GB.lighting.s.call_deferred('post')
#the chunk builder
func buildChunk(chunkPos=null):
	if chunkPos==null:chunkPos=curChunkCenter
	if loadedChunks.has(chunkPos):return
	
	#stores it as an empty chunk for helping out
	if(!chunkData.has(chunkPos)):
		var lChunk=SaveSystem.loadChunk(chunkPos)
		chunkData[chunkPos]=lChunk[0]
		chunkEntities[chunkPos]=lChunk[1]
	if !chunkEntities.has(chunkPos):chunkEntities[chunkPos]=[]
	else:
		loadChunkEntities(chunkPos,chunkEntities[chunkPos])
		chunkEntities[chunkPos]=[]
	var fullChunkData=[[],[]]
	var chunkUpdates={}
	for x in chunkSize:for y in chunkSize:
		#builds the basic cell data
		var cell=Vector2i(x,y)+chunkPos*chunkSize
		
		var cellData=getCellData(cell)
		
		var cellID=[cellData[0][0],cellData[0][1]]
		
		#this resets cell position at the end for adding to the chunk data
		cell-=chunkPos*chunkSize
		if cellID[0]==1&&cellData[1]:
			chunkUpdates=insertUpdates(chunkUpdates,growTree(cell,chunkPos))
		#for the default cell before the checks
		
		#sets cellID if it is changed by the chunkdata already
		if chunkData[chunkPos][0][x][y]!=-2:cellID[0]=chunkData[chunkPos][0][x][y]
		if chunkData[chunkPos][1][x][y]!=-2:cellID[1]=chunkData[chunkPos][1][x][y]
		
		if chunkPos.x<0:cellID[0]=1
		chunkData[chunkPos][0][x][y]=cellID[0]
		chunkData[chunkPos][1][x][y]=cellID[1]
		
		#this one should be determined by if it is a cave or not to if it will be done
		if cellID[1]> -1:
			fullChunkData[1].append_array([x+y*65536,cellID[1],x+y*65536,cellID[1]])
		if cellID[0]> -1:
			fullChunkData[0].append_array([x+y*65536,cellID[0],x+y*65536,cellID[0]])
		
	if chunkPos.x<0:
		chunkUpdates={}
	
	#creates the chunk object then adds it to the chunkholder on the main thread
	var chunk=Chunk2D.new()
	chunk.fillChunk(fullChunkData,chunkPos)
	chunkHolder.call_deferred('add_child',chunk)
	chunk.set_deferred('position',chunkPos*chunkSize*8)
	loadedChunks[chunkPos]=chunk
	#applies trees to the chunks
	for update in chunkUpdates:
		updateCellsForChunks(update,chunkUpdates[update])

#gets single cell data for each chunk
func getCellData(cell):
	#this deals with getting all the noise values for you
	var noiseLayers=getNoiseLayers(cell)
	
	#use this when adding different biome types
#	var biome=getBiome()
	#currently worthless since cell rotation is gone in 4.0
	var _cellRot=0
	#id for the cell
	var cellID=1
	var cellIDback=1
	#the ground layer
	if(noiseLayers[0]>cell.y-64):
		cellID=-1
		cellIDback=-1
	if(noiseLayers[0]<cell.y-64):
<<<<<<< HEAD
		cellID=2
		cellIDback=2
		if(noiseLayers[0]<cell.y-66):cellID=3
	if noiseLayers[2]&&noiseLayers[3]< -1.175+cell.y/60:cellID=-1
	return [[cellID,cellIDback],noiseLayers[1]]
=======
		cellID=1
		cellIDback=1
		if(noiseLayers[0]<cell.y-66):cellID=2
	if(noiseLayers[2]<1):
		cellID=-1
	return [[cellID,cellIDback],noiseLayers]
>>>>>>> 410affe50b52150f84235c01553f82cd2690243c








#used for growing a tree
func growTree(cell,chunkPos):
	if !chunkData.has(chunkPos):storeEmptyChunk(chunkPos)
	var treeSize=5
	var chunkCellsUpdated={}
	var curChunk=chunkPos
	for y in treeSize:
		#default log
		var cellID=4
		#the leaves
		if y+3>treeSize:cellID=5
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
func updateCellsForChunks(chunk,chunkAndCells,layer:int=0):
	storeEmptyChunk(chunk)
	if !loadedChunks.has(chunk):return
	#every second index is the cell id
	for cell in chunkAndCells.size()/2:
		var cellPos=chunkAndCells[cell*2]
		chunkData[chunk][layer][cellPos.x][cellPos.y]=chunkAndCells[cell*2+1]
		loadedChunks[chunk].placeTile(true,cellPos,chunkAndCells[cell*2+1])













#the noise layers used by world generation
func getNoiseLayers(cellPos):
	return [
		#for the ground level
		round(terrainNoise0.get_noise_1d(cellPos.x)*baseTerrainStrength),
		#for placing trees
		terrainNoise0.get_noise_1d(cellPos.x*10)>0.25,
<<<<<<< HEAD
		#cave generation noise
		caveNoise2D(cellPos.x,cellPos.y),
		caveDepthNoise.get_noise_2dv(cellPos)
=======
		#the cave noise
		abs(caveNoise0.get_noise_2d(cellPos.x,cellPos.y)))+abs(caveNoise1.get_noise_2d(cellPos.x,cellPos.y)
>>>>>>> 410affe50b52150f84235c01553f82cd2690243c
		]

func storeEmptyChunk(chunkPos):
	if chunkData.has(chunkPos):return
	
	chunkData[chunkPos]=[[],[]]
	for l in 2:
		for c in chunkPos:
			chunkData[chunkPos][l].push_back([])
			for d in chunkSize:
				chunkData[chunkPos][l][c].push_back(-2)
#makes an empty chunk for saving
func makeEmptyChunk():
	
	var dat=[[],[]]
	for l in 2:
		for c in chunkSize:
			dat[l].push_back([])
			for d in chunkSize:
				dat[l][c].push_back(-2)
	return dat

#allows me to shrink the dictionary
func updateDictionary(dic,newDic):
	for key in newDic:
		if dic.has(key):
			dic[key]+=newDic[key]
		else:
			dic[key]=newDic[key]
	return dic

func insertUpdates(chunkUpdates,chunkUpdateData):
	for key in chunkUpdateData:
		if chunkUpdates.has(key):
			chunkUpdates[key].insert_array(chunkUpdateData[key])
		else:
			chunkUpdates[key]=chunkUpdateData[key]
	return chunkUpdates



func loadChunkEntities(chunk,list):
	for entityData in list:
		var entity=itemEntity.new()
		entity.myData=entityData[0]
		entity.global_position=chunk*128+entityData[1]*8+Vector2i(4,3)
		chunkHolder.add_child(entity)


func caveNoise2D(x,y):
	var a      : float = (caveNoise0.get_noise_2d(x, y) + 1.0) / 2.0
	var b      : float = (caveNoise1.get_noise_2d(x, y) + 1.0) / 2.0
	var border : float = 0.625

	return(float(
		a >= (0.6) and
		b >= (1.0 - border)      and
		b <= (-2.0 * border / (0.125 - 2.0))
	))
