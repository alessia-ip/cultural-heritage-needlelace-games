extends AnimationPlayer

@export var listenTo: Node2D
@export var closer: Button

var isOpen = false

func _ready():
	listenTo.connect("OpenUI", open)
	closer.pressed.connect(close)
	
	play("RESET")
	pass

func open():
	if(isOpen == false):
		print("OPEN THE UI")
		play("OpenUI")
		isOpen = true
	pass
	
func close():
	play("CloseUI")
	isOpen = false
	pass
	
	
