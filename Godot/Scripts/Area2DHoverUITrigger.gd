extends Area2D

@export var StateManager: Node

@export var LocalInspector: Control
@export var IsPickupable: bool
@export var AreaName: String

var MouseOverMe = false
var MouseCurrentlyOccupied = false

@export var ParentToMove: Node2D

@export var LeftPrompt: String
@export var RightPrompt: String
@export var NameString: String
@export var InfoString: String

@export var activeInMain: bool

#Signals and their requirements
signal BeginOccupy(occupiedAreaName: String)
signal StopOccupy
signal MouseOverInteractableItem(l, r, n, i)
signal MovingChild(toReorder: Node2D)
signal MouseOffInteractableItem

var isMoving = false

func _ready():
	#Connections for each required signal
	connect("mouse_entered", MouseOver); #Mouse enters the Area2D
	connect("mouse_exited", MouseExit); #Mouse exits the Area2D
	connect("BeginOccupy", MouseOccupied); #Mouse is occupied and cannot perform a second action at this time (right click or pick up)
	connect("StopOccupy", MouseFreed); #The mouse has ceased its previous action and is now avaliable for another task
	
	#Any local hover indicators are turned off on start
	LocalInspector.visible = false
	
	#This sets the order of the object selected on mouse click
	#Without these settings, the mouse click will affect all Area2D below it
	#With these settings, the mouse is stopped at the first Area2D underneath it
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	pass 
	
func _process(delta):
	
	if(activeInMain &&
	StateManager.currentState == StateManager.State.STATE_MAINVIEW):
	
		#If the mouse is hovering over this specific area2D
		#AND if the mouse is not currently in use for another action
		if(MouseOverMe && !MouseCurrentlyOccupied):
			#We want to emit a signal for the UI that we are hovering over this specific Area2D
			#Also transmit the necessary information about this Area2D to be added to the UI
			emit_signal("MouseOverInteractableItem", LeftPrompt, RightPrompt, NameString, InfoString)
			#while hovering, if the left mouse button has just been pressed, we continue in this id statement
			if(Input.is_action_just_pressed("MouseLeft")):
				#The left button is used to pick up objects in the scene
				#Thus, the mouse will always be occupied when the left button is held down after picking something up
				#We also keep track of which area, so we know which object is being picked up (without needed to make it a child of the mouse icon)
				emit_signal("BeginOccupy", AreaName)
			
			if(Input.is_action_just_pressed("MouseRight")):
				ExecuteSecondaryFunction()
		
		#If the mouse is still over an object
		#And the left button is released
		#We drop whatever object we're holding and signal that the mouse is now free for another action
		if(MouseOverMe):
			if(Input.is_action_just_released("MouseLeft")):
				emit_signal("StopOccupy")
		
		#This keeps the parent of this Area2D in sync with the mouse when it has been selected to carry
		if(isMoving):
			#This keeps the object's anchor point in line with the mouse position
			#TODO: Use the click position, rather than the ANCHOR position, to avoid oddly snapping the objects to the hand
			ParentToMove.position = get_global_mouse_position()		
		
	pass
	
func MouseOver():
	MouseOverMe = true
	LocalInspector.visible = true
	pass

func MouseExit():
	MouseOverMe = false
	LocalInspector.visible = false
	emit_signal("MouseOffInteractableItem")
	pass


func MouseOccupied(functionArguement):
	if(functionArguement != AreaName):
		MouseCurrentlyOccupied = true;
	else:
		#print(ParentToMove.name + " in the area script")
		
		#This signal is important in the "Sprites" Node script
		#Godot orders rendering based on the order of the sprites in the hiearchy, and misordered sprites are resolved in SpriteLayerOrganizer.gd
		emit_signal("MovingChild", ParentToMove)
		
		#This bool marks this Area2D as moveable, and is always only for the currently selected object
		isMoving = true
		
func MouseFreed():
	MouseCurrentlyOccupied = false;
	isMoving = false

	
func ExecuteSecondaryFunction():
	#TODO: This is what's meant to run on right click. it's highly variable, so we'll store this elsewhere, but keep the code to activate it consistent throughout
	print("Right click")
	match AreaName:
		"Pillow Area":
			PillowRightClick()
		_:
			pass
	pass
	
#possible secondary functions, based on the object

#Fabric secondary function
#This is to pin the fabric to the pillow
func FabricRightClick():
	
	pass


#Pillow secondary function
#This is to open the drawer
func PillowRightClick():
	StateManager.emit_signal("UPDATE_STATE", StateManager.State.STATE_OPENEDPILLOWDRAWER)
	pass

#This is to put it on your lap
