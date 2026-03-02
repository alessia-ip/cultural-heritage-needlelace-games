extends Area2D

var stitchable = false

var first  = false

signal selectedShape(a: Area2D)

func _ready():
	input_pickable = true
	print(self)


func _mouse_enter():
	print("entered")
	stitchable = true
	set_process(true)
	
func _mouse_exit():
	print("exited")
	stitchable = false


func _process(_delta):
	
	
	if (Input.is_action_pressed("MouseLeft")):
		print("MOUSE CLICKED")
		
		if stitchable == true:
			print("selected a shape")
			var a = self
			emit_signal("selectedShape", a)
		else:
			print("clicked")
