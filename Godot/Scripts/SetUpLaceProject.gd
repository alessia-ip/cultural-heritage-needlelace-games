extends Node

@export_category("State Changers")
@export var LacePillow : Node2D
@export var Dowel : Node2D
@export var LacePaperPattern : Node2D
@export var LaceScrapPaper : Node2D
@export var LaceFabric : Node2D
@export var Needle : Node2D
@export var SewingThread : Node2D
@export var SafetyPins : Node2D

@export_category("UI Objects")
#Goes back to the main state when pressed
@export var BackButton : TextureButton 
@export var ToDoListShow : TextureButton
@export var ToDoListHide : TextureButton

signal UPDATE_STATE
signal UPDATE_CAMERASTATE
signal REPORT_STATE

#These states are ONLY for this scene
enum State {
	STATE_MAINVIEW,
	STATE_OPENEDPILLOWDRAWER,
	STATE_NEEDLESETUP,
	STATE_TACKING,
	STATE_PINNING,
	STATE_TRANSITION
	}
	
var currentState: State = State.STATE_MAINVIEW
var previousState: State = State.STATE_MAINVIEW
var nextState: State = State.STATE_MAINVIEW

func _ready():
	connect("UPDATE_STATE", _update_current_state)
	pass

func _update_current_state(s):
	
	match currentState:
		State.STATE_MAINVIEW:
			print("Main State")
			currentState = State.STATE_TRANSITION
			previousState = State.STATE_MAINVIEW
			nextState = s
			emit_signal("UPDATE_CAMERASTATE", previousState, nextState)
			
		State.STATE_OPENEDPILLOWDRAWER:
			print("Drawer Open")
			currentState = State.STATE_TRANSITION
			previousState = State.STATE_OPENEDPILLOWDRAWER
			nextState = s
			emit_signal("UPDATE_CAMERASTATE", previousState, nextState)
		
		State.STATE_NEEDLESETUP:
			print("NeedleSetup")
			currentState = State.STATE_TRANSITION
			previousState = State.STATE_NEEDLESETUP
			nextState = s
			emit_signal("UPDATE_CAMERASTATE", previousState, nextState)
		
		State.STATE_TACKING:
			print("Tacking")
			currentState = State.STATE_TRANSITION
			previousState = State.STATE_TACKING
			nextState = s
			emit_signal("UPDATE_CAMERASTATE", previousState, nextState)
		
		State.STATE_PINNING:
			print("Pinning")
			currentState = State.STATE_TRANSITION
			previousState = State.STATE_PINNING
			nextState = s
			emit_signal("UPDATE_CAMERASTATE", previousState, nextState)
			
		State.STATE_TRANSITION:
			print("Transition")
			currentState = nextState
			previousState = State.STATE_TRANSITION
			pass
			
	print("State Updated to " + str(currentState))
	pass

func _input(event: InputEvent):
	if(event.is_action_pressed("testing")):
		_update_current_state(State.STATE_OPENEDPILLOWDRAWER)
	pass
	
func ReportState():
	emit_signal("REPORT_STATE", currentState)
