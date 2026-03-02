extends Node2D

@export var threadstarter: Node2D


func _process(delta):
	look_at(get_global_mouse_position())
	MoveTowardsMouse(delta)
	pass

func MoveTowardsMouse(t):
	var mousePos = get_global_mouse_position()
	var currentPos = position
	var newPos = currentPos.lerp(mousePos, t / 6)
	position = newPos
	
func _draw():
	var pos = threadstarter.global_position
	draw_circle(pos, 5, Color(0,0,0,1), true)
