extends Area2D

var isTheTarget: bool = false

@export var listItem: Control

@export var IsTakeable: bool = false

@export var HoverText: String

signal hov(t: String)
signal left

var MouseCursors

func _ready():
	MouseCursors = get_node("%MouseSetup")

func _mouse_enter():
	isTheTarget = true
	hov.emit(HoverText)
	ChangeCursorHover()
	print(HoverText)
	pass
	
func _mouse_exit():
	isTheTarget = false
	left.emit()
	ChangeCursorUnhover()
	pass

func _process(delta):
	if(Input.is_action_just_pressed("MouseLeft") and isTheTarget):
		if(IsTakeable):
			var listCheckbox: CheckBox = listItem.get_child(1)
			var listText: RichTextLabel = listItem.get_child(0)
			listCheckbox.button_pressed = true
			var originalText = listText.text
			listText.bbcode_enabled = true
			var newText = "[s]" + originalText + "[/s]"
			listText.text = newText
			get_parent().visible = false
			ChangeCursorUnhover()
		pass
	pass

func ChangeCursorHover():
	MouseCursors.openHand()
	pass
	
func ChangeCursorUnhover():
	MouseCursors.pointingHand()
	pass
