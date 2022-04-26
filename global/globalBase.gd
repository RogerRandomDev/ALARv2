extends Node

const Tiles=preload("res://gameTiles.tres")
var chunkAssemble=load("res://global/chunkBuilder.gd").new()

func _ready():
	chunkAssemble.chunkHolder=get_tree().current_scene
	chunkAssemble._ready()
#this sets the current chunk to load, then activates the chunkloader
func loadChunk(chunkPos):
	chunkAssemble.curChunkToBuild=chunkPos
	chunkAssemble.semaphore.post()


func _input(event):
	if Input.is_key_pressed(KEY_A):
		loadChunk(Vector2i(0,0))
