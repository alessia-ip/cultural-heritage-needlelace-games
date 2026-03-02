extends Node2D

var isMouseDown = false

var kidColl: Array[Node]

var Area2DKids: Array[Area2D]

var checkpointArray: Array[bool]

var currentlyOverArray: Array[bool]

var Stitching: bool = false

@export var bastingLine: Line2D

var finishedB: bool = false

signal finishedBasting

var MouseCursors

func _ready():
	MouseCursors = get_node("%MouseSetup")
	
	ClearBastingStitch()
	
	kidColl = get_children()
	for kid in kidColl:
		if kid is Area2D:
			Area2DKids.append(kid)
			kid.connect("MouseEnteredMe", checkpoint)
			kid.connect("MouseExitedMe", checkIfFailed)
			checkpointArray.append(false)
			currentlyOverArray.append(false)
			pass

func _process(delta: float):
	if(Input.is_action_just_pressed("MouseLeft")):
		print("Mouse clicked")
		isMouseDown = true
		pass
	if(Input.is_action_just_released("MouseLeft")):
		restart()
		ChangeCursorMain()
		pass
		
	if(Stitching):
		BastingStitch()
		
	pass
	

func restart():
	Stitching = false
	ClearBastingStitch()
	isMouseDown = false
	checkpointArray.clear()
	currentlyOverArray.clear()
	for k in Area2DKids:
		checkpointArray.append(false)
		currentlyOverArray.append(false)
	timer()
	pass
	
func finish():
	print("All checkpoints reached")
	finishedB = true
	bastingLine.closed = true
	emit_signal('finishedBasting')
	ChangeCursorMain()
	pass
	
func checkpoint(coll: Node):
	if(isMouseDown):
		ChangeCursorNeedle()
		
		Stitching = true
		
		
		print("Checkpoint reached")
		var k = Area2DKids.find(coll)
		currentlyOverArray[k] = true
		
		
		var i = kidColl.find(coll)
		checkpointArray[i] = true
		
		var p = 0
		
		for c in checkpointArray:	
			if c == true:
				p = p + 1
		
		print("Number of checkpoints reached is  " + str(p))
		
		if p == kidColl.size():
			finish()
			pass
		
func checkIfFailed(coll: Node):
	var k = Area2DKids.find(coll)
	currentlyOverArray[k] = false
	
	var failed
	
	for b in currentlyOverArray:
		if b == false:
			failed = true
			print("no")
		else:
			failed = false
			break
	
	if failed:
		print("failed")
		#ChangeCursorNo()
		restart()
		
	pass


func BastingStitch():
	if(!finishedB):
		var LastPoint
		var MousePos = get_global_mouse_position()
		if(bastingLine.points.size() >= 1):
			LastPoint = bastingLine.points[bastingLine.points.size() - 1]
			if(MousePos.distance_to(LastPoint) > 0.01):
				bastingLine.add_point(MousePos)
				pass
		else:
			bastingLine.add_point(MousePos)
			pass
	pass
	
	
func ClearBastingStitch():
	if(!finishedB):
		bastingLine.clear_points()
	pass



func ChangeCursorNeedle():
	MouseCursors.NeedleHand()
	pass
	
func ChangeCursorNo():
	MouseCursors.NoHand()
	pass
	
func ChangeCursorMain():
	MouseCursors.pointingHand()
	pass

var i = 0

func timer():
	if (i < 19):
		i = i + 1
		timer()
	elif(i == 20):
		i = 0
		ChangeCursorMain()
	
	
		
