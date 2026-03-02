extends Node2D

@export var Stage6UI: Control

@export var StageSevenHolder: Node2D

@export var thingsToMove: Node2D

@export  var pinSignal: Node2D

signal stageFinished

func _ready(): 
	pinSignal.connect("pinnedOut", NextStage)
	#doneBut.pressed.connect(NextStage)
	pass

func NextStage():
	emit_signal("stageFinished")
	Stage6UI.visible = false
	
	var moveableChildren = thingsToMove.get_children()
	
	for c in moveableChildren:
		if c is Polygon2D:
			var NEW = c.duplicate()
			StageSevenHolder.add_child(NEW)
		if c is Line2D:
			var NEW = c.duplicate()
			StageSevenHolder.add_child(NEW)
	
	pass
