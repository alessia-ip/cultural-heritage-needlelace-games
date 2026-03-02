extends Node2D

@export_category("Buttons")

@export var MergeButton: Button
@export var ClipButton: Button
@export var IntersectButton: Button
@export var ExcludeButton: Button
@export var ResetButton: Button

@export_category("Polygons")
	
@export var PolyOne: Polygon2D
@export var PolyTwo: Polygon2D

@export var PolygonHolder: Node2D
var ResultPoly: Polygon2D

var testHover: Script = load("res://Scripts/test_hover_polygon.gd")



func _ready():
	MergeButton.pressed.connect(merge)
	ClipButton.pressed.connect(clip)
	IntersectButton.pressed.connect(intersect)
	ExcludeButton.pressed.connect(exclude)
	ResetButton.pressed.connect(reset)
	
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	
	pass
	
func merge():
	reset()
	
	var newArray: PackedVector2Array = Geometry2D.merge_polygons(PolyTwo.polygon, PolyOne.polygon)[0]
	print(newArray.size())
	
	print("NEW POLYGON")
	var newPolygon = Polygon2D.new()
	PolygonHolder.add_child(newPolygon)
	newPolygon.set_polygon(newArray)
	newPolygon.color = Color(0.35, 0.73, 0.11, 0.55)
	
	ResultPoly = newPolygon
	hoverAttach(ResultPoly)
	
	PolyOne.visible = false
	PolyTwo.visible = false

	pass
	
func clip():
	reset()
	
	var newArray: PackedVector2Array = Geometry2D.clip_polygons(PolyTwo.polygon, PolyOne.polygon)[0]
	print(newArray.size())
	
	var newarrays = Geometry2D.clip_polygons(PolyTwo.polygon, PolyOne.polygon)
	
	print("NEW POLYGON")
	var newPolygon = Polygon2D.new()
	PolygonHolder.add_child(newPolygon)
	newPolygon.set_polygon(newArray)
	newPolygon.color = Color(0.35, 0.73, 0.11, 0.55)
	
	ResultPoly = newPolygon
	
	PolyOne.visible = false
	PolyTwo.visible = false
	
	hoverAttach(ResultPoly)
	
	if(newarrays.size()>0):
		for a in newarrays:
			var newPolygon2 = Polygon2D.new()
			ResultPoly.add_child(newPolygon2)
			newPolygon2.set_polygon(a)
			newPolygon2.color = Color(0.35, 0.73, 0.11, 0.55)
			hoverAttach(newPolygon2)
	
	pass

func intersect():
	reset()
	
	var newArray: PackedVector2Array = Geometry2D.intersect_polygons(PolyTwo.polygon, PolyOne.polygon)[0]
	print(newArray.size())
	
	print("NEW POLYGON")
	var newPolygon = Polygon2D.new()
	PolygonHolder.add_child(newPolygon)
	newPolygon.set_polygon(newArray)
	newPolygon.color = Color(0.35, 0.73, 0.11, 0.55)
	
	ResultPoly = newPolygon
	
	hoverAttach(ResultPoly)
	
	PolyOne.visible = false
	PolyTwo.visible = false
	
	pass

func exclude():
	reset()
	
	var newArray: PackedVector2Array = Geometry2D.exclude_polygons(PolyTwo.polygon, PolyOne.polygon)[0]
	print(newArray.size())
	
	var newarrays = Geometry2D.exclude_polygons(PolyTwo.polygon, PolyOne.polygon)
	
	print("NEW POLYGON")
	var newPolygon = Polygon2D.new()
	PolygonHolder.add_child(newPolygon)
	newPolygon.set_polygon(newArray)
	newPolygon.color = Color(0.35, 0.73, 0.11, 0.55)
	
	ResultPoly = newPolygon
	
	hoverAttach(ResultPoly)
	
	PolyOne.visible = false
	PolyTwo.visible = false
	
	if(newarrays.size()>0):
		for a in newarrays:
			var newPolygon2 = Polygon2D.new()
			ResultPoly.add_child(newPolygon2)
			newPolygon2.set_polygon(a)
			newPolygon2.color = Color(0.35, 0.73, 0.11, 0.55)
			hoverAttach(newPolygon2)
	
	pass
	
func reset():
	if(ResultPoly != null):
		ResultPoly.queue_free()
	PolyOne.visible = true
	PolyTwo.visible = true
	pass

func hoverAttach(poly: Polygon2D):
	var newArea = Area2D.new()
	var newCollider = CollisionPolygon2D.new()
	
	newArea.set_script(testHover)
	newCollider.set_polygon(poly.polygon)
	
	poly.add_child(newArea)
	newArea.add_child(newCollider)
	
	
