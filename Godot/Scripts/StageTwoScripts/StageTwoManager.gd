extends Node2D

signal stageFinished

var signalled = false

@export var BastingNode: Node2D

@export var TransferElements: Array[Node2D]

@export var StageFourBasting: Node2D

func _ready():
	BastingNode.connect('finishedBasting', sceneDone)

func sceneDone():
	emit_signal('stageFinished')
	
	for e in TransferElements:
		var newE = e.duplicate()
		StageFourBasting.add_child(newE)
		#newE.reparent(StageFourBasting)
		newE.set_meta("Type", "Basting")
	
	pass
	
