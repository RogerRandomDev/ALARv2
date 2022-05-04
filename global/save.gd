extends Node

var file=File.new()

func saveChunk(chunkPos,chunkData,chunkEntities):
	if chunkPos.x<0:return
	file.open(GB.getSavePath()+"chunks/%s.dat"%chunkPos,File.WRITE)
	file.store_string(var2str([chunkData,chunkEntities]))
	file.close()

func loadChunk(chunkPos):
	var path=GB.getSavePath()+"chunks/%s.dat"%chunkPos
	if !file.file_exists(path):return [GB.chunkAssemble.makeEmptyChunk(),[]]
	file.open(path,File.READ)
	var content=str2var(file.get_as_text())
	file.close()
	return content

#deals with entities outside of a loaded chunk so it is simpler on me
func insertEntitiesToChunk(chunk,entityset):
	var path=GB.getSavePath()+"chunks/%s.dat"%chunk
	var contents=""
	if !file.file_exists(path):contents=[GB.chunkAssemble.makeEmptyChunk(),[]]
	else:
		file.open(path,File.READ)
		contents=str2var(file.get_as_text())
		file.close()
	contents[1].append_array(entityset)
	file.open(path,File.WRITE)
	file.store_line(var2str(contents))
	file.close()
