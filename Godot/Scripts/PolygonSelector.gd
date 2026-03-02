extends Area2D

var selectable: bool = false

signal selectedShape(selectedPoly: Polygon2D)

func process(delta):
	if(Input.is_action_just_pressed("MouseLeft") and selectable):
		clicked()
		pass
	pass

func _mouse_enter():
	selectable = true
	pass
	
func _mouse_exit():
	selectable = false
	pass
	
func clicked():
	emit_signal("selectedShape", get_parent())
	pass
