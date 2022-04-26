extends Node
#we need to put the noise functions here
const chunkSize=16
var curChunkToBuild=Vector2i.ZERO
#this holds the node that will have chunks inside of it
var chunkHolder=null
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
		buildChunk(curChunkToBuild)

#the chunk builder
func buildChunk(chunkPos=null):
	print("a")
	if chunkPos==null:chunkPos=curChunkToBuild
	#scales up chunk position to match chunk size
	chunkPos*=chunkSize
	var fullChunkData=[[],[]]
	for xy in chunkSize*chunkSize:
		var cell=Vector2i(xy%chunkSize,round(xy/chunkSize))+chunkPos
		#currently worthless since cell rotation is gone in 4.0
		var cellRot=0
		#id for the cell
		var cellID=0
		
		
		#this resets cell position at the end for adding to the chunk data
		cell-=chunkPos
		#loads the format for each cell in the tilemap array format
		fullChunkData[0].append_array([cell.x+(cell.y*65536),cellID,0])
		#this one should be determined by if it is a cave or not to if it will be done
		fullChunkData[1].append_array([cell.x+(cell.y*65536),cellID,0])
	#creates the chunk object then adds it to the chunkholder on the main thread
	var chunk=Chunk2D.new()
	
	chunk.fillChunk(fullChunkData,chunkPos)
	chunkHolder.add_child(chunk)
	
