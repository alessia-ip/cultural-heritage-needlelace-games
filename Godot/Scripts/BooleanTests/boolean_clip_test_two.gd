extends Node2D

var testHover: Script = load("res://Scripts/test_hover_polygon.gd")




var run = false

var pRun = true

@export var runButt: Button

var NumOfRuns: int = 0 

func _ready():
	var Poly: Array[Polygon2D]
	var children = get_children()
	for c in children:
		if c is Polygon2D:
			Poly.append(c)
			hoverAttach(c)
	
	print(Poly.size())
	runButt.pressed.connect(runF)
	
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true

func BooleanSeparations():
	var Poly: Array[Polygon2D]
	
	await get_tree().create_timer(0.5).timeout

	NumOfRuns = NumOfRuns + 1
	
	print("This is run " + str(NumOfRuns))
	
	#get child polygons
	var children = get_children()
	for c in children:
		if c is Polygon2D:
			if(c.polygon.size() < 3):
				c.queue_free()
			else:	
				Poly.append(c)
	
	for p in Poly:	
		#get the area2d
		var pC = p.get_children()
		var pA: Area2D
		for c in pC:
			if c is Area2D:
				pA = c
		
		await get_tree().process_frame
		
		if pA.has_overlapping_areas():
			#we want to interact with the overlaps
			var overlappingAreas = pA.get_overlapping_areas()
			
			for o in overlappingAreas:
				var oParent = o.get_parent()
				
				#make sure they are not the same node
				if(oParent != p):
					exclude(p, oParent)
					intersect(p, oParent)
			
			remove_child(p)
			p.queue_free()
	
	Poly.clear()		
	cleanup()
	
	pass

func cleanup():
	
	await get_tree().create_timer(0.5).timeout
	
	var Poly: Array[Polygon2D]
	
	var removed = 0 
	
	var children = get_children()
	for c in children:
		if c is Polygon2D:
			if c.polygon.size() > 2:
				Poly.append(c)
				hoverAttach(c)
			else:
				c.queue_free()
	
	for p in Poly:
		for p2 in Poly:
			if p != p2:
				if p is Polygon2D and p2 is Polygon2D:
					
					var array1: Array[Vector2]
					var array2: Array[Vector2]
					
					for v in p.polygon:
						array1.append(v)
						
					for v in p2.polygon:
						array2.append(v)
					
					if array1 == array2:
						print("is equivalent")
						remove_child(p2)
						p2.queue_free()
						var i = Poly.find(p2)
						Poly.remove_at(i)
						removed = removed + 1
						print("Removed: " + str(removed))
	
	if(removed != 0):
		Poly.clear()
		cleanup()
	else:
		for p in Poly:
			if p.polygon.size() < 3:
				remove_child(p)
				p.queue_free()
		Poly.clear()
		var PolyCheck: Array[Polygon2D]
		children = get_children()
		for c in children:
			if c is Polygon2D:
				PolyCheck.append(c)
	
		var shouldRunAgain = false
		
		for p in PolyCheck:
				print(p.get_children())
				for c in p.get_children():
					if c is Area2D:
						print("has area")
						await get_tree().process_frame
						if(c.has_overlapping_areas()):
							print(c.get_overlapping_areas().size())
							shouldRunAgain = true
		
		if(shouldRunAgain):					
			BooleanSeparations()				
		
	
	
	

func exclude(p, o):
	var newExcludeArray: Array[PackedVector2Array] = Geometry2D.exclude_polygons(p.polygon, o.polygon)
	
	for c in newExcludeArray:
		var newPolygon = Polygon2D.new()
		self.add_child(newPolygon)
		newPolygon.set_polygon(c)
		pass
	
	pass

func intersect(p, o):
	var newIntersectArray: Array[PackedVector2Array] = Geometry2D.intersect_polygons(p.polygon, o.polygon)
	
	for c in newIntersectArray:
		var newPolygon = Polygon2D.new()
		self.add_child(newPolygon)
		newPolygon.set_polygon(c)
		pass
		
	pass

func hoverAttach(poly: Polygon2D):
	
	var children = poly.get_children()
	var hasArea2d = false
	
	for c in children:
		if c is Area2D:
			hasArea2d = true
	
	if(hasArea2d == false):
		var newArea = Area2D.new()
		newArea.set_script(testHover)
		poly.add_child(newArea)	

		var pv: PackedVector2Array
		
		for vertex in poly.polygon:
			var truncX = roundf(vertex.x)
			var truncY = roundf(vertex.y)
			
			var vert = Vector2(truncX, truncY)
			
			if(vert not in pv):
				pv.append(vert)
				
			pass
		
		
		if(pv.size() > 2):
		
			var listoflines = getLinesList(pv)
			
			var valid = true
			
			
			for l1 in listoflines.size():
				for l2 in listoflines.size():
					if(l1 != l2):
						var P = GetIntersectionPoints(listoflines[l1], listoflines[l2])
						if(P != null):
							valid = false
							
			if valid == true && pv.size() > 2:
				var hulls = Geometry2D.decompose_polygon_in_convex(pv)
					
				if(hulls.size()> 1):
					for h in hulls:
						var newCollider = CollisionPolygon2D.new()
						newCollider.set_polygon(h)
						newArea.add_child(newCollider)
				elif(hulls.size() == 1):
					var newCollider = CollisionPolygon2D.new()
					newCollider.set_polygon(hulls[0])
					newArea.add_child(newCollider)
				else: 
					poly.queue_free()
			else:
				poly.queue_free()
		else:
			poly.queue_free()

func runF():
	if run == false:
		BooleanSeparations()
		run = true
		runButt.visible = false

func getLinesList(poly: PackedVector2Array):
	
	var LineList: Array[Vector4]
	
	for p in poly.size():
		var p1
		var p2
		
		if(p != poly.size() - 1):
			p1  = poly[p]
			p2  = poly[p + 1]
		else: 
			p1  = poly[0]
			p2  = poly[p]
		var Vec4 = Vector4(p1.x, p1.y, p2.x, p2.y)
		LineList.append(Vec4)
		pass
	
	return(LineList)

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
