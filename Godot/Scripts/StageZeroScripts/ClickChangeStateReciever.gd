extends Node2D

signal state_changed(state)

@export var childOpen: Sprite2D
@export var childClosed: Sprite2D

var isOpen: bool = false

func _ready():
	_changeState(true)
	
	var childOpenArea = childOpen.get_child(0)
	childOpenArea.connect("state_changed", _changeState)
	
	var childClosedArea = childClosed.get_child(0)
	childClosedArea.connect("state_changed", _changeState)
	pass

func _changeState(state):
	isOpen = !state
	print(isOpen)
	if(isOpen):
		childOpen.visible = true
		childClosed.visible = false
	else:
		childOpen.visible = false
		childClosed.visible = true
	pass
