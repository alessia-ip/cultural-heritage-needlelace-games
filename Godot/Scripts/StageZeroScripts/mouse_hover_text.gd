extends Control

var RTL: RichTextLabel
var CR: ColorRect

@export var p: Node2D


func _ready():
	RTL = find_child("RichTextLabel")
	CR = find_child("ColorRect")
	var pChildren = p.find_children("Area2D", "", true, false)
	for c in pChildren:
		if c.has_signal("hov"):
			print("Added connection to " + str(c))
			c.connect("hov", change_text)
			c.connect("left", hide_text)
	RTL.visible = false
	CR.visible = false

func _process(delta):
	position = get_global_mouse_position()
	pass

func change_text(t: String):
	print("Changing text to " + t)
	RTL.text = t
	RTL.visible = true
	CR.visible = true
	pass
	
func hide_text():
	RTL.visible = false
	CR.visible = false
	pass
	
	
