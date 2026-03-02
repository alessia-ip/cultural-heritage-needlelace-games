extends Area2D

var clickable: bool = false

@export var pinOne: Sprite2D
@export var pinTwo: Sprite2D

signal PinnedIn

func _ready():
	pinOne.visible = false
	pinTwo.visible = false

func _process(delta: float):
	if(Input.is_action_just_pressed("MouseLeft")):
		if(clickable):
			turnPinOn()

func _mouse_enter():
	clickable = true
	pass
	
func _mouse_exit():
	clickable = false
	pass

func turnPinOn():
	if(pinOne.visible == false):
		pinOne.visible = true
	elif(pinOne.visible == true and pinTwo.visible == false):
		pinTwo.visible = true
	
	checkIfDone()
	pass

func checkIfDone():
	if(pinOne.visible == true and pinTwo.visible == true):
		emit_signal("PinnedIn")
		
