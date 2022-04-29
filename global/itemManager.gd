extends Node

var allItems=[]


var s=Semaphore.new()
var thread=Thread.new()
func _ready():
	thread.start(update_items)


#deals with the item updates to make them faster
func update_items():
	while true:
		s.wait()
		for item in allItems:
			item.check_overlapping_items()

func process(_delta):
	s.post()
