extends Node2D

@export var threadStarter: Node2D

var circleArray: Array[Vector2]
var dirArray: Array[Vector2]
var prevPos: Vector2 

var isOver = true

func _process(delta):
	AddCircleToArray()
	if(Input.is_action_just_pressed("MouseLeft")):
		isOver = !isOver

func AddCircleToArray():
	var newPos = threadStarter.global_position
	if(isOver):
		circleArray.append(newPos)
		if(prevPos != null):
			var newDir = newPos.direction_to(prevPos)
			dirArray.append(newDir)
	elif(!isOver):
		circleArray.push_front(newPos)
		if(prevPos != null):
			var newDir = newPos.direction_to(prevPos)
			dirArray.push_front(newDir)
		
	
	prevPos = newPos
	queue_redraw()
	
func _draw():
	var rad = 12.0
	for n in circleArray.size():
		var vec: Vector2 = circleArray[n]
		var dir: Vector2 = dirArray[n]
		var dir2: Vector2 = dir.rotated(90)
		
		
		draw_circle(vec, rad, Color(0.5,0.5,0.5,1), true)
		
		var lineC1: Vector2 = vec + (rad * dir2)
		var lineC1a = lineC1 + (rad /2 * dir)
		#var lineC1b = lineC1 - (rad /2 * dir)
		#draw_circle(lineC1, 3, Color(0,0,0,1), true)
		draw_line(lineC1a, lineC1, Color(0,0,0,1), 4)
		
		var lineC2: Vector2 = vec - (rad * dir2)
		var lineC2a = lineC2 + (rad /2 * dir)
		#var lineC1b = lineC2 - (rad /2 * dir)

		draw_line(lineC2a, lineC2, Color(0,0,0,1), 4)
		
		draw_circle(vec, rad, Color(0.5,0.5,0.5,1), true)
