extends Node2D

var drawnLines: Array[Vector2] = []
var pastPos: Vector2 = Vector2(INF, INF)

@export var paper: Area2D

@export var Instructions: Node2D

var pencilText: Texture2D = load("res://Images/PencilTexture.png")

@export var paperViewport: SubViewport

var MouseCursors

func _ready():
	MouseCursors = get_node("%MouseSetup")

func _process(delta: float):
	if(Instructions.visible == false):
	
		if(Input.is_action_pressed("MouseLeft")):
			print("DRAWING ON PAPER")
			ChangeCursorPencil()
			var currentPos: Vector2
			if(pastPos == Vector2(INF, INF)):
				currentPos = get_global_mouse_position()
			else:
				currentPos = pastPos.lerp(get_global_mouse_position(), delta * 2)
			drawnLines.append(currentPos)
			queue_redraw()
			pastPos = currentPos
			pass
		if(Input.is_action_pressed("MouseRight")):
			ChangeCursorEraser()
			var currentPos: Vector2 = get_global_mouse_position()
			for v in drawnLines:
				if(v.distance_to(currentPos) < 15.0):
					drawnLines.erase(v)
			queue_redraw()
			pass
		pass
		
		if(Input.is_action_just_released("MouseLeft")):
			ChangeCursorMain()
			pastPos = Vector2(INF, INF)
			var img = paperViewport.get_texture().get_image()
			img.save_png("user://DrawnPattern.png")
			
		if(Input.is_action_just_released("MouseRight")):
			ChangeCursorMain()

func _draw():
	for v in drawnLines:
		#draw_circle(v, 12, Color(1,1,1,1))
		draw_texture(pencilText, v - Vector2(12,12), Color(1, 1, 1, 0.3))
		pass
	pass

func ChangeCursorPencil():
	MouseCursors.pencilHand()
	pass
	
func ChangeCursorEraser():
	MouseCursors.EraserHand()
	pass
	
func ChangeCursorMain():
	MouseCursors.pointingHand()
	pass
