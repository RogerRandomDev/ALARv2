extends CharacterBody2D


const SPEED = 64.0
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


func _ready():
	add_child(heldImage)
	print(ItemSystem.get_item_data("Dirt"))
	heldImage.top_level=true
	last_chunk=GB.posToChunk(global_position)
	var timer=Timer.new()
	timer.wait_time=0.5
	timer.autostart=true
	timer.connect('timeout',check_chunk)
	add_child(timer)
	inventory._ready()
	hand=load("res://holdingScripts/drill.gd").new()
	hand.holdImage=heldImage
	hand._ready()


func _physics_process(delta):
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
