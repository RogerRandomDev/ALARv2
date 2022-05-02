extends Node

var myTime=null
func _enter_tree():
	get_tree().connect("node_added",on_scene_change)


func on_scene_change(a):
	if get_tree().current_scene.name!="worldBase":
		myTime=null
		return
	if myTime!=null:return
	var timeScene=preload("res://scenes/global/Time.tscn").instantiate()
	get_tree().current_scene.add_child(timeScene)
	myTime=timeScene
