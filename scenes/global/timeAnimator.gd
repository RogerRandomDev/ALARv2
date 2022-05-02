extends AnimationPlayer


var timeData=load("res://WorldData/time.tres")
var allAlter=null
var sky=null

func _ready():
	sky=get_parent().get_node("CanvasLayer/Sky")
	allAlter=get_parent().get_node("timeModulate")
	buildTimeAnimation()
	play("time")



#moves the time animation points to the right spot
func buildTimeAnimation():
	var anim=self.get_animation("time")
	anim.track_set_key_time(0,0,timeData.DayTime*30)
	anim.track_set_key_time(0,1,timeData.DuskTime*30)
	anim.track_set_key_time(0,2,timeData.NightTime*30)


func setCurTime(timeName:String):
	var tween:Tween=create_tween()
	tween.tween_property(sky,"color",timeData.get(timeName+"Color"),1.5)
	tween.parallel().tween_property(allAlter,"color",timeData.get(timeName+"ColorMod"),1.5)
