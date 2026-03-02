extends Button

var hov = false
var prevHov = false

@export var helpNode: Node2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	helpNode.visible = false

func _process(delta):
	hov = is_hovered()
	if(prevHov != hov):
		if(hov):
			showHelp()
		else:
			hideHelp()
		prevHov = hov	
		pass

func showHelp():
	print("Show Help Text")
	helpNode.visible = true
	pass
	
func hideHelp():
	print("Hide Help Text")
	helpNode.visible = false
	pass
	
