extends Node2D

@export var OpenHand: Sprite2D
@export var ClosedHand: Sprite2D
@export var PointingHand: Sprite2D
@export var Pin: Sprite2D
@export var Pencil: Sprite2D
@export var Eraser: Sprite2D
@export var ThumbsUp: Sprite2D
@export var Needle: Sprite2D
@export var MagnifyingGlass: Sprite2D
@export var No: Sprite2D

var isClosed = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	turnOff()
	pointingHand()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePosition = get_global_mouse_position()
	position = mousePosition
	
	if(Input.is_action_pressed("MouseLeft") and OpenHand.visible == true):
		closeHand()
		
	if(Input.is_action_pressed("MouseLeft") and OpenHand.visible == true):
		closeHand()
		
	if(Input.is_action_just_released("MouseLeft") and isClosed):
		openHand()
		
	if(Input.is_action_just_released("MouseLeft") and isClosed):
		openHand()
		
	pass
	
	
func openHand():
	turnOff()
	OpenHand.visible = true
	
func closeHand():
	turnOff()
	ClosedHand.visible = true
	isClosed = true

func pointingHand():
	turnOff()
	PointingHand.visible = true
	
func pinHand():
	turnOff()
	Pin.visible = true
	
func pencilHand():
	turnOff()
	Pencil.visible = true
	
func EraserHand():
	turnOff()
	Eraser.visible = true
	
func ThumbsHand():
	turnOff()
	ThumbsUp.visible = true
	
func NeedleHand():
	turnOff()
	Needle.visible = true

func NoHand():
	turnOff()
	No.visible = true
	
func MagHand():
	turnOff()
	MagnifyingGlass.visible = true

func turnOff():
	OpenHand.visible = false
	ClosedHand.visible = false
	PointingHand.visible = false
	Pin.visible = false
	Pencil.visible = false
	Eraser.visible = false
	ThumbsUp.visible = false
	Needle.visible = false
	MagnifyingGlass.visible = false
	No.visible = false
	
	isClosed = false
	
