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
func loadItems(loc="res://Data/"):
	var inner=getInnerFile(loc)
	var returned={}
	for folderName in inner:
		var innerResources=getInnerFile(loc+folderName)
		for item in innerResources:
			if item.count(".")>1:continue
			var it=load(loc+folderName+"/%s"%item)
			it.loadSelf()
			returned[item.split(".")[0]]=it.get_data()
	return returned
#loads item recipes
func loadRecipes(loc="res://Recipes/"):
	var inner=getInnerFile(loc)
	var returned=[]
	for folderName in inner:
		var recipe=load(loc+folderName)
		var inp=recipe.get_recipe()
		returned.push_back(inp)
	return returned



func loadTexturePack(packName:String):
	var dir=Directory.new()
	var path="user://resourcePacks/%s"%packName
	if !dir.dir_exists(path):return
	var new_textures=getInnerFile(path)
	
	for tex in new_textures:
		if ItemSystem.allItems.has(tex.trim_suffix(".png")):
			
			ItemSystem.allItems[tex.trim_suffix(".png")].icon=path+"/%s"%tex
			if ItemSystem.allItems[tex.trim_suffix(".png")].item_id>0:
				GB.Tiles.get_source(ItemSystem.allItems[tex.trim_suffix(".png")].item_id).texture=GB.load_external_texture(path+"/%s"%tex)
	
