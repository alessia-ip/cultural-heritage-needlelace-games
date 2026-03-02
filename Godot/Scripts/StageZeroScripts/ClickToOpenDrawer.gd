extends Area2D

@export var DrawerNumber: int

signal drawer_opened(drawerNumber)

var isTheTarget: bool = false

var MouseCursors

func _ready():
	MouseCursors = get_node("%MouseSetup")

func _mouse_enter():
	isTheTarget = true
	ChangeCursorHover()
	pass
	
func _mouse_exit():
	isTheTarget = false
	ChangeCursorUnhover()
	pass

func _process(delta):
	if(Input.is_action_just_pressed("MouseLeft") and isTheTarget):
		drawer_opened.emit(DrawerNumber)
		print("Sending " + str(DrawerNumber))
		ChangeCursorUnhover()
	pass
	
func ChangeCursorHover():
	MouseCursors.MagHand()
	pass
	
func ChangeCursorUnhover():
	MouseCursors.pointingHand()
	pass
