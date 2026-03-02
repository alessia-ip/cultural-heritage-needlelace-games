extends Node2D

signal stageFinished

@export var stitchingElements: Node2D
@export var stageUI: Control

@export var PolygonHolder: Node2D
@export var NewPolyHolder: Node2D

@export var OutlineHolder: Node2D

@export var Basting: Node2D

var pSelector: Script = load("res://Scripts/StageFive/PolygonSelector.gd")

func _ready():
	stitchingElements.connect("finishedStitching", finish)

func finish():
	var bCopy = Basting.duplicate()
	
	NewPolyHolder.add_child(bCopy)
	
	
	var polygons = PolygonHolder.get_children()
	
	for p in polygons:
		if p is Polygon2D:
			#var newLine = Line2D.new()
			#newLine.set_meta("Type", "Outline")
			#newLine.points = p.polygon
			#newLine.closed = true
			#newLine.width = 3
			p.reparent(NewPolyHolder)
			p.color = Color(0,0,0,0)
			#p.add_child(newLine)
			
			var areas = p.get_children()
			for a in areas:
				if a is Area2D:
					a.set_script(pSelector)
					
	var lines = OutlineHolder.get_children()
	
	for l in lines:
		if l is Line2D:
			var newL = l.duplicate()
			NewPolyHolder.add_child(newL)
			newL.width = 3
			newL.set_meta("Type", "Outline")
		
			
	
	emit_signal("stageFinished")
	stageUI.visible = false
	
