extends Node

var mineTexture=preload("res://Textures/MineSheet.png")
var progress=0.0;
var holdImage=null
var mining_point=Vector2.ZERO
func _ready():
	holdImage.texture=mineTexture
	holdImage.centered=false
	holdImage.region_enabled=true
func update(delta):
	if Input.is_mouse_button_pressed(1):
		holdImage.visible=true
		progress+=delta*GB.playerStats.mineSpeed
		var holdPos=holdImage.get_parent().get_global_mouse_position()
		if holdPos.x<0:return
		holdImage.position=holdPos
		holdPos-=holdImage.get_parent().global_position
		if holdPos.length_squared()>576:
			holdImage.position=holdPos.normalized()*24+holdImage.get_parent().global_position
		holdPos+=holdImage.get_parent().global_position
		holdImage.global_position=Vector2i(holdImage.global_position/8)*8
		if holdPos.x<0:holdImage.global_position.x-=8
		if holdPos.y<0:holdImage.global_position.y-=8
		if holdImage.global_position!=mining_point||GB.getCellAtPoint(holdImage.global_position)==-1:
			mining_point=holdImage.global_position
			
			progress=0.0
			holdImage.visible=false
		holdImage.region_rect=Rect2(int(round(progress*5)*8),0,8,8)
	else:
		progress=0
		holdImage.visible=false
	if progress>=1.2:
		progress=0.0;
		var mPos=mining_point
		if mPos.x<0&&mPos.x> -12:mPos.x+=4
		if mPos.y<0&&mPos.y> -12:mPos.y+=4
		var pos=GB.posToChunkAndCell(mPos)
		if mPos.x< -8:pos[1].x+=1
		if mPos.y< -8:pos[1].y+=1
		if pos[1].x>15:
			pos[0].x-=1;pos[1].x-=16
		GB.mineCellFromChunk(pos[0],pos[1])
