extends Node
class_name folderReader



func getInnerFile(file_location):
	var dir=Directory.new()
	dir.open(file_location)
	dir.list_dir_begin()
	var files=[]
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files

func readFiles(fileList,location):
	var fileReader=File.new()
	var outputs=[]
	for file in fileList:
		fileReader.open(location+file,File.READ)
		outputs.push_back(fileReader.get_as_text())
		fileReader.close()
	return outputs


#loads the item contents
func loadItems():
	var loc="res://Data/blocks/"
	var inner=getInnerFile(loc)
	var returned={}
	for item in inner:
		returned[item.split(".")[0]]=load(loc+item).get_data()
	return returned
