extends CollisionShape2D

signal mouseEnteredMe(CollisionShape2D)

func _mouse_enter():
	print("Mouse enter col shape 2d")
	emit_signal("mouseEnteredMe", self)
	pass
