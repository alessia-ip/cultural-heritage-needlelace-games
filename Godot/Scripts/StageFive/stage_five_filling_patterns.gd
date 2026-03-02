extends Node2D

@export var doneBut: Button
@export var Stage5UI: Control

@export var StageSixHolder: Node2D

@export var thingsToMove: Node2D

signal stageFinished

func _ready(): 
	doneBut.pressed.connect(NextStage)

func NextStage():
	emit_signal("stageFinished")
	Stage5UI.visible = false
	
	var moveableChildren = thingsToMove.get_children()
	
	for c in moveableChildren:
		var NEW = c.duplicate()
		if NEW is Polygon2D:
			NEW.process_mode = Node.PROCESS_MODE_DISABLED
		StageSixHolder.add_child(NEW)
	
	pass
