extends Area2D

signal MouseEnteredMe
signal MouseExitedMe
	
func _mouse_enter():
	print("mouse entered")
	emit_signal("MouseEnteredMe", self)
	pass

func _mouse_exit():
	print("mouse exited")
	emit_signal("MouseExitedMe", self)
	pass
