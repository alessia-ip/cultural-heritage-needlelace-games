extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePosition = get_global_mouse_position()
	position = mousePosition
	pass
