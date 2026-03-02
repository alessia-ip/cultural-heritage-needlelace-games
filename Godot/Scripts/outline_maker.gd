extends Node2D

@export var OutlinesHolder: Node2D
@export var GhostLine: Line2D
@export var LineColor: Color

var stitching: bool = false

var currentStitchingLine: Line2D

var UnsplitLineList: Array[Vector4]

var IntersectPointsList: Array[Vector2]
var SortedIntersectPointsList: Array[Vector2]

var NewLinesList: Array[Vector4]
var VertsList: Array[Vector2]
var EdgeList: Array 

var astarOne = AStar2D.new()
var astarTwo = AStar2D.new()
var aStarDictOne: Dictionary
var aStarDictTwo: Dictionary

var testTexture: Texture2D = load("res://Images/TestTexture.png")

var testThreadTexture: Texture2D = load("res://Images/StitchingOutline.png")


@export var PolygonHolder: Node2D

func _ready():
	GhostLine.visible = false
	
	#Test cases
	#var test = GetIntersectionPoints(Vector4(0, 2, 3, 4), Vector4(1, 3, 3, 1))
	#GetIntersectionPoints(Vector4(1, 1, 5, 1), Vector4(1, 2, 5, 2))
	pass

func _process(delta):
	queue_redraw()
	
	#if not currently stitching, begin a new line
	if(!stitching):
		if(Input.is_action_just_pressed("MouseLeft")):
			StartOutlineStitches()
			pass
		pass
	elif(stitching):
		RenderGhostLine()
		if(Input.is_action_just_pressed("MouseLeft")):
			AddNewStitch()
			pass
		if(Input.is_action_just_pressed("MouseRight")):
			EndOutlineStitches()
			pass
		pass
		
	if(Input.is_action_just_pressed("testing")):
		
		Finish()
		
	pass
	
	
func RenderGhostLine():
	if(stitching):
		GhostLine.visible = true
		var pos = get_global_mouse_position()
		var pC = currentStitchingLine.get_point_count()
		var lPos = currentStitchingLine.get_point_position(pC - 1)
		GhostLine.set_point_position(0, pos)
		GhostLine.set_point_position(1, lPos)
		pass
		
	pass
	
func StartOutlineStitches():

	stitching = true
	currentStitchingLine = Line2D.new()
	
	#Properties
	currentStitchingLine.texture = testThreadTexture;
	currentStitchingLine.texture_mode = Line2D.LINE_TEXTURE_TILE;
	currentStitchingLine.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED;
	
	currentStitchingLine.default_color = LineColor
	currentStitchingLine.width = 150
	
	#Hierarchy
	OutlinesHolder.add_child(currentStitchingLine)
	
	#Position
	var pos = get_global_mouse_position()
	currentStitchingLine.add_point(pos)
	pass
	
func AddNewStitch():
	var pos = get_global_mouse_position()
	currentStitchingLine.add_point(pos)
	AddNewLineToUnsplitList()
	pass
	
func EndOutlineStitches():
	stitching = false
	GhostLine.visible = false

	pass
	
func Finish():
	MakeNewLines()
	pass
	

func AddNewLineToUnsplitList():
	var pC = currentStitchingLine.get_point_count()
	var x1 = currentStitchingLine.get_point_position(pC-2).x
	var y1 = currentStitchingLine.get_point_position(pC-2).y
	var x2 = currentStitchingLine.get_point_position(pC-1).x
	var y2 = currentStitchingLine.get_point_position(pC-1).y
	var nVec4 = Vector4(x1, y1, x2, y2)
	UnsplitLineList.append(nVec4)
	print(UnsplitLineList)
	pass

func MakeNewLines():
	
	NewLinesList.clear()
	
	#For every unsplit line created until the player finishes
	for l1 in UnsplitLineList.size():
	
		IntersectPointsList.clear()
		for l2 in UnsplitLineList.size():
		
			if(l1 != l2):
				var P = GetIntersectionPoints(UnsplitLineList[l1], UnsplitLineList[l2])
				
				# If the lines intersect with each other, we add a new point to the intersection list
				if(P != null):
					IntersectPointsList.append(P)
					pass
				pass
				
			pass
		
		
		OrderPointsInList(UnsplitLineList[l1])
		GenNewLines()
		pass
	GenPolygons()
	pass
		
func GenNewLines():
	# From the calculated intersections, make new line segments based on the intersections instead
	for i in range(0, SortedIntersectPointsList.size() - 1):
		var newx1y1: Vector2 = SortedIntersectPointsList[i]
		var newx2y2: Vector2 = SortedIntersectPointsList[i+1]
		var newline: Vector4 = Vector4(newx1y1.x, newx1y1.y, newx2y2.x, newx2y2.y)
		NewLinesList.append(newline)
		pass
	pass


func OrderPointsInList(l1):
	
	SortedIntersectPointsList.clear()
	
	#First, collect all the new possible points in a list
	var x1y1 = Vector2(l1.x, l1.y)
	var x2y2 = Vector2(l1.z, l1.w)
	
	SortedIntersectPointsList.append(x1y1)
	
	for point in IntersectPointsList:
		SortedIntersectPointsList.append(point)
		
	SortedIntersectPointsList.append(x2y2)
	
	SortedIntersectPointsList.sort_custom(GetClosest)
	
	pass
	
func GetClosest(a, b):
	var dist1 = SortedIntersectPointsList[0].distance_to(a)
	var dist2 = SortedIntersectPointsList[0].distance_to(b)
	if dist1 > dist2:
		return true
	return false
	

func _draw():
	#if(NewLinesList.size() > 0):
		#var i = 0
		#for l in NewLinesList:
			#i = i + 0.1
			#draw_line(Vector2(l.x, l.y), Vector2(l.z, l.w), Color(i,i,0,1), 20.0)
			#pass
			#
	#if(VertsList.size() > 0):
		#for v in VertsList:
			#draw_circle(v, 20.0, Color(0,0,0,1), true)
	pass

func GetIntersectionPoints(AB: Vector4, CD: Vector4):
	
	#Line one
	var x1 = AB.x
	var y1 = AB.y
	var x2 = AB.z
	var y2 = AB.w
	
	#Line two
	var x3 = CD.x
	var y3 = CD.y
	var x4 = CD.z
	var y4 = CD.w
	
	var 	α = ((x4 - x3)*(y3 - y1) - (y4 - y3)*(x3 - x1)) / ((x4 - x3)*(y2 - y1) - (y4 - y3)*(x2 - x1))
	
	var β = ((x2 - x1)*(y3 - y1) - (y2 - y1)*(x3 - x1)) / ((x4 - x3)*(y2 - y1) - (y4 - y3)*(x2 - x1))
	
	
	if(α != INF && β != INF):
		if(0 < α && α < 1 && 0 < β && β < 1 ):
			var x0 = x1 + α*(x2-x1)
			var y0 = y1 + α*(y2 - y1)
			
			if(x0 != x1 && x0 != x2):
				if(y0 != y1 && y0 != y2):
					#This is the point where the two lines meet
					var P = Vector2(x0, y0)	
					return(P)

func MakeVertsList():
	EdgeList.clear()
	for l in NewLinesList:
		var start = Vector2(l.x, l.y)
		var end = Vector2(l.z, l.w)
		if(!VertsList.has(start)):
			VertsList.append(start)
			pass
		if(!VertsList.has(end)):
			VertsList.append(end)
			pass
			
		EdgeList.append( [start, end] )
		
		
		pass
	print("There are " + str(EdgeList.size()) + " edges.")
	print(EdgeList)
	pass
	
func MakeAstarList():
	for v in VertsList:
		#if these don't exist in astar, add them
		#we keep track of the value and the key in a dictionary to reference against
		if(aStarDictOne.has(v) == false):
			var newAstarId = astarOne.get_available_point_id()
			aStarDictOne[v] = newAstarId
			astarOne.add_point(newAstarId, v)
			print("Astar ID in dictionary one " + str(newAstarId) + " is for vertex " + str(v))
			pass
		
		if(aStarDictTwo.has(v) == false):
			var newAstarId = astarTwo.get_available_point_id()
			aStarDictTwo[v] = newAstarId
			astarTwo.add_point(newAstarId, v)
			#print("Astar ID in dictionary 2 " + str(newAstarId) + " is for vertex " + str(v))
			pass
			
		pass
	
	# Since these are unidirectional connections, we make two separate astar lists to hold them
	
	for E in EdgeList:
		var vert1 = E[0]
		var vert2 = E[1]
		
		var vert1ID = aStarDictOne[vert1]
		var vert2ID = aStarDictOne[vert2]
		
		astarOne.connect_points(vert1ID, vert2ID, true)
		
		
		pass
	
	for E in EdgeList:
		var vert1 = E[0]
		var vert2 = E[1]
		
		var vert1ID = aStarDictTwo[vert1]
		var vert2ID = aStarDictTwo[vert2]
		
		astarTwo.connect_points(vert2ID, vert1ID, true)
		
		pass
		
	pass
	
func MakePolygons():
	
	# We can then create polygons from our collected data. 
	# By getting the shortest path from a vertex back to itself, we can find enclosed polygons from an 
	# arbitrary set of user defined line segments. 
	
	for v in VertsList:
		var a1ID = aStarDictOne.get(v)
		
		for vert in astarOne.get_point_ids():
			if(a1ID != vert):
				if(astarOne.are_points_connected(a1ID, vert)):
					astarOne.disconnect_points(a1ID, vert)
					var possiblePolygon = astarOne.get_point_path(vert, a1ID)
					print(possiblePolygon.size())
					if(possiblePolygon.size() > 2):
						var newPolygon = Polygon2D.new()
						PolygonHolder.add_child(newPolygon)
						newPolygon.set_polygon(possiblePolygon)
						#newPolygon.color = Color(0.73, 0.35, 0.11, 0.55)
						
						
						newPolygon.uv = possiblePolygon
						newPolygon.set_texture(testTexture)
						newPolygon.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
						newPolygon.texture_scale = Vector2(2,2)
						
						print("Astar 1 polygon")
						print(possiblePolygon)
						pass
					astarOne.connect_points(a1ID, vert, true)
					pass
				pass	
			pass
		pass

	for v in VertsList:
		var a2ID = aStarDictTwo.get(v)
		
		for vert in astarTwo.get_point_ids():
			if(a2ID != vert):
				if(astarTwo.are_points_connected(a2ID, vert)):
					astarOne.disconnect_points(a2ID, vert)
					var possiblePolygon = astarTwo.get_point_path(vert, a2ID)
					print(possiblePolygon.size())
					if(possiblePolygon.size() > 2):
						var newPolygon = Polygon2D.new()
						PolygonHolder.add_child(newPolygon)
						newPolygon.set_polygon(possiblePolygon)
						newPolygon.color = Color(0.35, 0.73, 0.11, 0.55)
						print("Astar 2 polygon")
						pass
					astarOne.disconnect_points(a2ID, vert, true)
					pass
				pass	
			pass

	pass

func GenPolygons():
	MakeVertsList()
	MakeAstarList()
	MakePolygons()
	pass
