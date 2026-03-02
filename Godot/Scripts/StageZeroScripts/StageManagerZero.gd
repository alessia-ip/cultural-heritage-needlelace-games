extends Node2D

var hand = load("res://Images/TestArt/Hand.png")

var checkBoxes: Array[CheckBox]

signal stageFinished

var signalled = false

func _ready():
	#Input.set_custom_mouse_cursor(hand, 0, Vector2(10,10))
	
	for child in find_children("*", "", true, false):
		if child is CheckBox:
			checkBoxes.append(child)
		pass
	
	pass

func _process(delta):
	
	if signalled == false:
		var i = 0
		
		for c: CheckBox in checkBoxes:
			if c.button_pressed == true:
				i = i + 1
				pass
				
		if( i == checkBoxes.size()):
			print("Got all the items I needed")
			emit_signal("stageFinished")
			signalled = true
