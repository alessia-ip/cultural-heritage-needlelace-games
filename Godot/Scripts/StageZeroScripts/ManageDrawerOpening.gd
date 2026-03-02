extends Node2D

signal drawer_opened(drawerNumber)

var ListOfChildAreas:Array[Area2D] = []

@export var OpenedDrawerNodes: Node2D
@export var OpenedCupboardNodes: Node2D

@export var DrawerZeroContents: Node2D
@export var DrawerOneContents: Node2D
@export var DrawerTwoContents: Node2D
@export var DrawerThreeContents: Node2D
@export var DrawerFourContents: Node2D
@export var DrawerFiveContents: Node2D
@export var DrawerSixContents: Node2D
@export var DrawerSevenContents: Node2D

@export var CupboardEightContents: Node2D

var AllDrawers: Array[Node2D]

func _ready():
	
	AllDrawers.append(DrawerZeroContents)
	AllDrawers.append(DrawerOneContents)
	AllDrawers.append(DrawerTwoContents)
	AllDrawers.append(DrawerThreeContents)
	AllDrawers.append(DrawerFourContents)
	AllDrawers.append(DrawerFiveContents)
	AllDrawers.append(DrawerSixContents)
	AllDrawers.append(DrawerSevenContents)
	AllDrawers.append(CupboardEightContents)
	
	for child in get_children():
		if child is Area2D:
			ListOfChildAreas.append(child)
			pass
		pass
	
	for child in ListOfChildAreas:
		child.connect("drawer_opened", _openTheCorrespondingDrawer)
		print("Connected " + str(child))
		pass

	pass

func _openTheCorrespondingDrawer(drawerNumber):
	print("Recieved from drawer: " + str(drawerNumber))
	for drawer in AllDrawers:
		drawer.visible = false
	match drawerNumber:
		0:
			OpenedDrawerNodes.visible = true
			DrawerZeroContents.visible = true
			pass
		1:
			OpenedDrawerNodes.visible = true
			DrawerOneContents.visible = true
			pass
		2:
			OpenedDrawerNodes.visible = true
			DrawerTwoContents.visible = true
			pass
		3:
			OpenedDrawerNodes.visible = true
			DrawerThreeContents.visible = true
			pass
		4:
			OpenedDrawerNodes.visible = true
			DrawerFourContents.visible = true
			pass
		5:
			OpenedDrawerNodes.visible = true
			DrawerFiveContents.visible = true
			pass
		6:
			OpenedDrawerNodes.visible = true
			DrawerSixContents.visible = true
			pass
		7:
			OpenedDrawerNodes.visible = true
			DrawerSevenContents.visible = true
			pass
		8:
			OpenedCupboardNodes.visible = true
			CupboardEightContents.visible = true
			pass
	
	pass
