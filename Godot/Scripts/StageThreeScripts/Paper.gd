extends Area2D

@export var isPaper: bool = false

func _mouse_enter():
	print("Paper!")
	isPaper = true
	pass
	
func _mouse_exit():
	isPaper = false
	pass
