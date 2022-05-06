extends Sprite2D





var time=0.0
func _process(delta):
	time+=delta
	scale=Vector2(1+sin(time)/8,1+sin(time)/8)
