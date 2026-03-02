extends Node2D

@export var pinSignal: Area2D

signal stageFinished

func _ready(): 
	pinSignal.connect("PinnedIn", NextStage)

func NextStage():
	emit_signal("stageFinished")
	pass
