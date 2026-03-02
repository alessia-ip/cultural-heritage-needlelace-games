extends Node2D

var testHover: Script = load("res://Scripts/test_hover_polygon.gd")

@export var runButt: Button

var originalPolygons: Array[Polygon2D]
var clipPolygons: Array[Polygon2D]
var intersectPolygons: Array[Polygon2D]

var allPolys: Array[Polygon2D]
var exclusionPolygons: Array[Polygon2D]

var mergedArea: Polygon2D

func _ready():
	var children = get_children()
	for child in children:
		if child is Polygon2D:
			originalPolygons.append(child)
			
	runButt.pressed.connect(begin)
			
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true

func begin():
	booleanSeparation()
	pass
	
func booleanSeparation():
	mergeOriginalShapes()
	getClipAreas()
	getIntersectAreas()
	removeDuplicates()
	getExclusions()
	removeDuplicates()
	addHover()
	pass
	

func mergeOriginalShapes():
	var prevPoly: PackedVector2Array
	
	for poly in originalPolygons:
		if(prevPoly.size() == 0):
			prevPoly = poly.polygon
		else:
			var newShape = Geometry2D.merge_polygons(prevPoly, poly.polygon)[0]
			prevPoly = newShape
		poly.visible = false
	
	var NewPolygon = Polygon2D.new()
	NewPolygon.set_polygon(prevPoly)
	NewPolygon.color = Color(0.5,0.5,0.5, 1)
	mergedArea = NewPolygon
	add_child(mergedArea)
	
	pass
	
func getClipAreas():
	
	for poly in originalPolygons:
		var prevPoly: PackedVector2Array =  poly.polygon.duplicate()
		
		for poly2 in originalPolygons:
			if(poly != poly2):
				var newShape = Geometry2D.clip_polygons(prevPoly, poly2.polygon)
				if(newShape.size() != 0):
					prevPoly = newShape[0]
		
		var newVectors: PackedVector2Array
		
		for p in prevPoly:
			var newVectorX = roundf(p.x)
			var newVectorY = roundf(p.y)
			var newVectorFull = Vector2(newVectorX, newVectorY)
			if(newVectors.has(newVectorFull) != true):
				newVectors.append(newVectorFull)
		
		var NewPolygon = Polygon2D.new()
		NewPolygon.set_polygon(newVectors)
		NewPolygon.color = Color(0.5,0.3,0.8, 1)
		add_child(NewPolygon)
		clipPolygons.append(NewPolygon)
		
	pass
	
func getIntersectAreas():
	
	for poly in originalPolygons:
		var prevPoly: PackedVector2Array =  poly.polygon.duplicate()
		
		for poly2 in originalPolygons:
			if(poly != poly2):
				var newShape = Geometry2D.intersect_polygons(prevPoly, poly2.polygon)
				if(newShape.size() != 0):
					prevPoly = newShape[0]
		
		var newVectors: PackedVector2Array
		
		for p in prevPoly:
			var newVectorX = roundf(p.x)
			var newVectorY = roundf(p.y)
			var newVectorFull = Vector2(newVectorX, newVectorY)
			if(newVectors.has(newVectorFull) != true):
				newVectors.append(newVectorFull)
		
		var NewPolygon = Polygon2D.new()
		NewPolygon.set_polygon(newVectors)
		NewPolygon.color = Color(0.5,0.3,0.8, 1)
		add_child(NewPolygon)
		intersectPolygons.append(NewPolygon)
	
	
	pass
	
func removeDuplicates():
	var allPolygons: Array[PackedVector2Array]

	for p in clipPolygons:
		var poly = p.polygon
		if(allPolygons.has(poly)):
			print("Removed")
			p.queue_free()
			clipPolygons.erase(p)
		else:
			allPolygons.append(poly)
			allPolys.append(p)
			
	for p in intersectPolygons:
		var poly = p.polygon
		if(allPolygons.has(poly)):
			print("Removed")
			p.queue_free()
			intersectPolygons.erase(p)
		else:
			allPolygons.append(poly)
			allPolys.append(p)
	
	for p in exclusionPolygons:
		var poly = p.polygon
		if(allPolygons.has(poly)):
			print("Removed")
			p.queue_free()
			exclusionPolygons.erase(p)
		else:
			allPolygons.append(poly)
			allPolys.append(p)
	
	pass
	
func getExclusions():
	for poly in originalPolygons:
		var prevPoly: PackedVector2Array =  mergedArea.polygon.duplicate()
		
		for poly2 in originalPolygons:
			if(poly2 != poly):
				var newShape = Geometry2D.exclude_polygons(poly2.polygon, prevPoly)
				print(newShape.size())
				if(newShape.size() != 0):
						prevPoly = newShape[0]
		
		for poly2 in clipPolygons:
			var newShape = Geometry2D.exclude_polygons(poly2.polygon, prevPoly)
			print(newShape.size())
			if(newShape.size() != 0):
					prevPoly = newShape[0]
					
		for poly2 in intersectPolygons:
			var newShape = Geometry2D.exclude_polygons(poly2.polygon, prevPoly)
			print(newShape.size())
			if(newShape.size() != 0):
					prevPoly = newShape[0]
					
		var newVectors: PackedVector2Array
		
		for p in prevPoly:
			var newVectorX = roundf(p.x)
			var newVectorY = roundf(p.y)
			var newVectorFull = Vector2(newVectorX, newVectorY)
			if(newVectors.has(newVectorFull) != true):
				newVectors.append(newVectorFull)
		
		var NewPolygon = Polygon2D.new()
		NewPolygon.set_polygon(newVectors)
		NewPolygon.color = Color(0.5,0.3,0.8, 1)
		add_child(NewPolygon)
		exclusionPolygons.append(NewPolygon)
		print("exclusions:" + str(exclusionPolygons.size()))
		
	pass

func addHover():
	mergedArea.visible = false
	
	for poly in originalPolygons:
		poly.visible = false
			
	for poly in clipPolygons:
		var newArea = Area2D.new()
		newArea.set_script(testHover)
		poly.add_child(newArea)	
		
		var shapes = Geometry2D.decompose_polygon_in_convex(poly.polygon)
		for s in shapes:
			var newCollider = CollisionPolygon2D.new()
			newCollider.set_polygon(s)
			newArea.add_child(newCollider)
		
	for poly in intersectPolygons:
		var newArea = Area2D.new()
		newArea.set_script(testHover)
		poly.add_child(newArea)	
		
		var shapes = Geometry2D.decompose_polygon_in_convex(poly.polygon)
		for s in shapes:
			var newCollider = CollisionPolygon2D.new()
			newCollider.set_polygon(s)
			newArea.add_child(newCollider)
			
	for poly in exclusionPolygons:
		var newArea = Area2D.new()
		newArea.set_script(testHover)
		poly.add_child(newArea)	
		
		var shapes = Geometry2D.decompose_polygon_in_convex(poly.polygon)
		for s in shapes:
			var newCollider = CollisionPolygon2D.new()
			newCollider.set_polygon(s)
			newArea.add_child(newCollider)
			
	print(intersectPolygons.size() + exclusionPolygons.size() + clipPolygons.size())
		
