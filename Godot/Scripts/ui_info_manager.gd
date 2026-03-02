extends Control

@export_category("Things I Reference")
@export var InfoPillow: Area2D
@export var InfoFabric: Area2D

@export_category("Things I Manage")
@export var PromptsGen: Control
@export var ItemInfoGen: Control
@export var TextRectR: RichTextLabel
@export var TextRectL: RichTextLabel
@export var TextRectN: RichTextLabel
@export var TextRectI: RichTextLabel
@export var RightPrompt: Control

var MouseBusy = false

func _ready():
	HideUI()
	InfoPillow.connect("MouseOverInteractableItem", GetMouseoverInfo)
	InfoFabric.connect("MouseOverInteractableItem", GetMouseoverInfo)
	InfoPillow.connect("MouseOffInteractableItem", HideUI)
	InfoFabric.connect("MouseOffInteractableItem", HideUI)
	InfoPillow.connect("BeginOccupy", Occupied)
	InfoFabric.connect("BeginOccupy", Occupied)
	InfoPillow.connect("StopOccupy", UnOccupied)
	InfoFabric.connect("StopOccupy", UnOccupied)
	pass

func _process(delta):
	if(MouseBusy):
		HideUI()

func GetMouseoverInfo(l, r, n, i):
	TextRectL.text = l
	if(r == ""):
		RightPrompt.visible = false
	elif(r != ""):
		RightPrompt.visible = true
		TextRectR.text = r
	#print(n)
	#print(i)
	ShowUI()
	pass
	
func ShowUI():
	PromptsGen.visible = true
	PromptsGen.visible = true
	pass
	
	
func HideUI():
	PromptsGen.visible = false
	PromptsGen.visible = false
	pass

func Occupied(v):
	MouseBusy = true
	
func UnOccupied():
	MouseBusy = false
