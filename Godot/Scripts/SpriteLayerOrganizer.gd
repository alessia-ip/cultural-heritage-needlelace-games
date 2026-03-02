extends Node2D

@export var SpriteTopLevelOrg: Node2D

var SpriteChildren: int

@export var MoveableFabric: Area2D
@export var MoveablePillow: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SpriteChildren = SpriteTopLevelOrg.get_child_count()
	print(SpriteChildren)
	print("Sprite Org Active")
	MoveableFabric.connect("MovingChild", ReorderChildren)
	MoveablePillow.connect("MovingChild", ReorderChildren)
	pass


func ReorderChildren(f):
	#print(f)
	move_child(f, SpriteChildren)
	pass
