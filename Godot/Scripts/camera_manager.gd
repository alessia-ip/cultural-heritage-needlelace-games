extends Node

@export var SceneManager: Node
 
@export_category("Cameras")
@export var MainSceneCamera: Camera2D
@export var TackingCamera: Camera2D
@export var DrawerCamera: Camera2D
@export var PinningCamera: Camera2D
@export var TransitionCamera: Camera2D

var StartingPoint: Camera2D
var EndingPoint: Camera2D

var cameraIsMoving = false
var dTime = 0.0

func _ready():
	SceneManager.connect("UPDATE_CAMERASTATE", StartTransitionCameras)
	TransitionCamera.make_current()
	TransitionCamera.position = MainSceneCamera.position
	TransitionCamera.zoom = MainSceneCamera.zoom
	pass

func _process(delta):
	if(cameraIsMoving):
		dTime += delta
		MoveTransCamera()
	pass
	
func StartTransitionCameras(startingState, endingState):
	print("Starting transition")
	match startingState:
		SceneManager.State.STATE_MAINVIEW:
			StartingPoint = MainSceneCamera
			pass
		SceneManager.State.STATE_OPENEDPILLOWDRAWER:
			StartingPoint = DrawerCamera
			pass
		SceneManager.State.STATE_NEEDLESETUP:
			pass
		SceneManager.State.STATE_TACKING:
			pass
		SceneManager.State.STATE_PINNING:
			pass
		SceneManager.State.STATE_TRANSITION:
			pass
		pass
	
	match endingState:
		SceneManager.State.STATE_MAINVIEW:
			EndingPoint = MainSceneCamera
			pass
		SceneManager.State.STATE_OPENEDPILLOWDRAWER:
			EndingPoint = DrawerCamera
			pass
		SceneManager.State.STATE_NEEDLESETUP:
			pass
		SceneManager.State.STATE_TACKING:
			pass
		SceneManager.State.STATE_PINNING:
			pass
		SceneManager.State.STATE_TRANSITION:
			pass
		pass
	
	#print("Interpolating from " + str(StartingPoint) + " to " + str(EndingPoint))
	#TransitionCamera.position = StartingPoint.position
	#TransitionCamera.make_current()
	cameraIsMoving = true
	#print(get_viewport().get_camera_2d())
	pass
	
func MoveTransCamera():
	#The new camera position is using the camera specifications of the start and end cameras provided
	var currentCamPos = TransitionCamera.global_position
	var endingPos = EndingPoint.global_position
	var newPos = currentCamPos.lerp(endingPos, dTime / 5)
	
	#The new camera zoom is also using the camera specifications of the start and end cameras provided
	var currentCamZ = TransitionCamera.zoom
	var endingZ = EndingPoint.zoom
	var newZ = currentCamZ.lerp(endingZ, dTime / 5)
	
	#These new values are then applied to the moving transition camera
	TransitionCamera.position = newPos
	TransitionCamera.zoom = newZ
	
	#Since there is an ease on the lerp, it takes far too long with the tiny incrementing at the end
	#This is checking that the values are 'close enough' to be considered done
	if is_equal_approx(currentCamPos.x, endingPos.x):
		if is_equal_approx(currentCamZ.x, endingZ.x):
			EndMoveCamera()
	pass
	
func EndMoveCamera():
	dTime = 0
	cameraIsMoving = false
	#EndingPoint.make_current()
	SceneManager.emit_signal("UPDATE_STATE", SceneManager.State.STATE_TRANSITION)
	print("Camera finished")
	pass
