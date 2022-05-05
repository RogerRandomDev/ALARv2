extends Node

var myTime=null
signal change_time(time:String,timeColor:Color)
func _enter_tree():
	get_tree().connect("node_added",on_scene_change)


func on_scene_change(_a):
	if get_tree().current_scene.name!="worldBase":
		myTime=null
		return
	if myTime!=null:return
	var timeScene=preload("res://scenes/global/Time.tscn").instantiate()
	timeScene.get_node("timeAnimator").root=self
	get_tree().current_scene.add_child(timeScene)
	myTime=timeScene
	
