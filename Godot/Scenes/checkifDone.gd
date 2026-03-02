extends Node2D

@export var pinOne :Sprite2D
@export var pinTwo :Sprite2D
@export var pinThree :Sprite2D
@export var pinFour :Sprite2D
@export var snipButton : Button

signal pinnedOut

func _process(delta: float):
	checkIfDone()

func checkIfDone():
	if(pinOne.visible == false and 
	pinTwo.visible == false and
	pinThree.visible == false and
	pinFour.visible == false and
	snipButton.visible == false):
		emit_signal("pinnedOut")
