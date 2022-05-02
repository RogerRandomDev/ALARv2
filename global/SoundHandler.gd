extends Node

var sounds=[]

func _ready():
	start_song("song0")



func start_song(song_name):
	var tween:Tween=create_tween()
	if sounds.size()>2:
		sounds[0].queue_free()
		sounds.remove_at(0)
	if sounds.size()!=0:
		var s=sounds[0]
		tween.tween_property(s,"volume_db",-40.,0.25)
	var n_song=AudioStreamPlayer.new()
	n_song.stream=load("res://Audio/Songs/%s.mp3"%song_name)
	n_song.volume_db=-40
	tween.parallel().tween_property(n_song,"volume_db",0.,0.25)
	sounds.push_back(n_song)
	add_child(n_song)
	n_song.play()
	
