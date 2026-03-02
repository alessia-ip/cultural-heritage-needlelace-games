extends Node2D

signal stageFinished

var signalled = false

func _process(delta: float):
	if (signalled == false):
		var fileExists = FileAccess.file_exists("user://DrawnPattern.png")
		if(fileExists == true):
			emit_signal("stageFinished")
			pass
		pass
