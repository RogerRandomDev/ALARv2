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
