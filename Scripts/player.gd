extends CharacterBody2D


const SPEED = 128.0
const JUMP_VELOCITY = -45.
@onready var sprite=$sprite
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_chunk=Vector2i.ZERO
#set to playerHand object when made
var hand=null
#inventory system
var inventory=load("res://customObjects/inventory.gd").new()
var heldImage=Sprite2D.new()

var active=true
func _ready():
	TimeHandler.connect("change_time",update_time)
	add_child(heldImage)
	GB.player=self
	heldImage.top_level=true
	last_chunk=GB.posToChunk(global_position)
	var timer=Timer.new()
	timer.wait_time=0.25
	timer.autostart=true
	timer.connect('timeout',check_chunk)
	call_deferred('add_child',timer)
	inventory._ready()
	hand=load("res://holdingScripts/drill.gd").new()
	hand.holdImage=heldImage
	hand._ready()


func _process(delta):
	if !active:return
	if hand!=null:hand.update(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h=direction<0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	animation_handler(direction)
	move_and_slide()
func _input(_event):
	#changes held item
	if _event is InputEventKey:update_hand(_event.keycode)

func update_hand(key):
	var to_hold=-1
	match key:
		49:to_hold=0
		50:to_hold=1
		51:to_hold=2
		52:to_hold=3
		53:to_hold=4
		54:to_hold=5
	if to_hold!=-1:
		if inventory.contents[to_hold].name==null:
			hold_item_type({"item_name":"empty"})
			return
		hold_item_type(ItemSystem.allItems[inventory.contents[to_hold].name],inventory.contents[to_hold].count,to_hold)

func check_chunk():
	var nchunk=GB.posToChunk(global_position)
	if last_chunk!=nchunk:GB.loadChunk(nchunk)
	last_chunk=nchunk

#handles animations
func animation_handler(moving):
	if is_on_floor()&&sprite.animation=="Jump":
		sprite.animation="Land"
	if !sprite.playing&&sprite.animation=="Land":
		sprite.animation="Move"
		sprite.playing=true
	if is_on_floor()&&moving:
		sprite.animation="Move"
		sprite.playing=true
	if is_on_floor()&&!moving&&sprite.animation=="Move":
		sprite.playing=false
	if is_on_floor()&&velocity.y<0:
		sprite.playing=true
		sprite.animation="Jump"



#switches item holding script when needed
func hold_item_type(item,holdCount:int=0,slot:int=-1):
	item=item.duplicate(true)
	#this is to handle empty hands
	if item.item_name=="empty":
		hand=load("res://holdingScripts/empty.gd").new()
		heldImage.visible=false
		return
	#if its a drill
	if item.item_name=="Drill":
		hand=load("res://holdingScripts/drill.gd").new()
		hand.holdImage=heldImage
		hand._ready()
	#the final else is for if it is just a block
	else:
		hand=load("res://holdingScripts/block.gd").new()
		hand.holdImage=heldImage
		hand.holding=item
		hand.holding.count=holdCount
		hand._ready()
		hand.update_holding(slot)



func update_time(cur_time:String,time_color:Color):
	var tween:Tween=create_tween()
	tween.tween_property($Sprite2D,"self_modulate",(Color.WHITE-time_color)+Color(0,0,0,float(cur_time!="Day")),1.5)
