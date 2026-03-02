extends Button

@export var parent: Control
@export var InstructionParent: Node2D

func _ready():
	pressed.connect(CloseParent)
	pass

func CloseParent():
	parent.visible = false
	parent.process_mode = Node.PROCESS_MODE_DISABLED
	InstructionParent.visible = false
	pass
