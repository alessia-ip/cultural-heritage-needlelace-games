extends Area2D

var parent: Polygon2D
var originalColor: Color = Color(0.8,0.4,0.7,0.5)

func _mouse_enter():
	parent = get_parent()
	parent.color = Color(0.5,0.5,0.5,0.5)

func _mouse_exit():
	parent = get_parent()
	parent.color = originalColor
