extends Node2D

var selectedPolygon: Polygon2D = null

var prevChildren = 0

@export_category("Color Buttons")
@export var redButton: Button
@export var orangeButton: Button
@export var yellowButton: Button
@export var greenButton: Button
@export var blueButton: Button
@export var purpleButton: Button
@export var blackButton: Button
@export var whiteButton: Button

var redCol = Color(0.97, 0.2, 0.509, 1)
var orangeCol = Color(0.902, 0.459, 0.251, 1)
var yellowCol = Color(0.937, 0.903, 0.542, 1)
var greenCol = Color(0.353, 0.705, 0 , 1)
var blueCol = Color(0.078, 0.596, 0.933, 1)
var purpleCol = Color(0.465, 0.117, 0.807, 1)
var blackCol = Color(0,0,0,1)
var whiteCol = Color(1,1,1,1)

@export_category("Style Buttons")
@export var ciaraButton: Button
@export var fissoButton: Button
@export var grecoButton: Button
@export var greco2Button: Button
@export var greco3Button: Button
@export var grecoRedinButton: Button
@export var panettiButton: Button
@export var rosalinaButton: Button
@export var sbariRigaButton: Button
@export var sbariConVoteviButton: Button

@export_category("Other Inputs")
@export var rotationSlider: HSlider
@export var finishEditButton: Button

var sizeDict = {"ciara" : 25, "fisso" : 25, "greco" : 25, "greco2" : 25, "greco3" : 25, "grecoRedin" : 25, "panetti" : 50, "rosalina" : 50, "sbariARiga" : 58, "sbariConVotevi" : 50}

var ciaraTexture: Texture2D = load("res://Images/Stitches/SacolaCiara.png")
var fissoTexture: Texture2D = load("res://Images/Stitches/Fisso.png")
var grecoTexture: Texture2D = load("res://Images/Stitches/Greco.png")
var greco2Texture: Texture2D = load("res://Images/Stitches/GrecoDaDo.png")
var greco3Texture: Texture2D = load("res://Images/Stitches/GrecoDaTre.png")
var grecoRedinTexture: Texture2D = load("res://Images/Stitches/GrecoRedin.png")
var panettiTexture: Texture2D = load("res://Images/Stitches/Panetti.png")
var rosalinaTexture: Texture2D = load("res://Images/Stitches/Rosalina.png")
var sbariRigaTexture: Texture2D = load("res://Images/Stitches/SbariARiga.png")
var sbariConVoteviTexture: Texture2D = load("res://Images/Stitches/SbariConVotevi.png")

signal OpenUI

@export var prev: Node2D

var rotating = false

func _ready():
	redButton.pressed.connect(updateColor.bind(redCol))
	orangeButton.pressed.connect(updateColor.bind(orangeCol))
	yellowButton.pressed.connect(updateColor.bind(yellowCol))
	greenButton.pressed.connect(updateColor.bind(greenCol))
	blueButton.pressed.connect(updateColor.bind(blueCol))
	purpleButton.pressed.connect(updateColor.bind(purpleCol))
	whiteButton.pressed.connect(updateColor.bind(whiteCol))
	blackButton.pressed.connect(updateColor.bind(blackCol))
	
	ciaraButton.pressed.connect(updateTexture.bind(ciaraTexture, sizeDict["ciara"]))
	fissoButton.pressed.connect(updateTexture.bind(fissoTexture, sizeDict["fisso"]))
	grecoButton.pressed.connect(updateTexture.bind(grecoTexture, sizeDict["greco"]))
	greco2Button.pressed.connect(updateTexture.bind(greco2Texture, sizeDict["greco2"]))
	greco3Button.pressed.connect(updateTexture.bind(greco3Texture, sizeDict["greco3"]))
	grecoRedinButton.pressed.connect(updateTexture.bind(grecoRedinTexture, sizeDict["grecoRedin"]))
	panettiButton.pressed.connect(updateTexture.bind(panettiTexture, sizeDict["panetti"]))
	rosalinaButton.pressed.connect(updateTexture.bind(rosalinaTexture, sizeDict["rosalina"]))
	sbariRigaButton.pressed.connect(updateTexture.bind(sbariRigaTexture, sizeDict["sbariARiga"]))
	sbariConVoteviButton.pressed.connect(updateTexture.bind(sbariConVoteviTexture, sizeDict["sbariConVotevi"]))
	
	
	rotationSlider.drag_started.connect(startRotation)
	rotationSlider.drag_ended.connect(endRotation)
	
	processChildren()
	pass


func _process(delta):
	var numOfChildren = get_children().size()

	if(numOfChildren != prevChildren):
		processChildren()
		prevChildren = numOfChildren	
		
	if(rotating):
		updateRotation()
	
	pass

func processChildren():
	var children = prev.get_children()
	for child in children:
		if child is Polygon2D:
			var cChildren = child.get_children()
			for c in cChildren:
				if c is Area2D:
					connectChild(c)
	pass
	
func connectChild(polyArea: Area2D):
	polyArea.connect("selectedShape", newPolygonSelected)
	pass

func updateColor(col: Color):
	if(selectedPolygon != null):
		selectedPolygon.color = col
		pass
		
		
	if(selectedPolygon.texture == null):
		updateTexture(ciaraTexture, sizeDict["ciara"])
	pass


func startRotation():
	rotating = true
	print("start rotation")
	pass
	
func endRotation():
	print("end rotation")
	rotating = false
	pass

func updateRotation():
	if(selectedPolygon != null):
		print("rotation is happening" + str(rotationSlider.value))
		selectedPolygon.texture_rotation = rotationSlider.value
		pass
	pass
	
func updateTexture(tex: Texture2D, size: int):
	if(selectedPolygon != null):
		selectedPolygon.texture = tex
		selectedPolygon.texture_scale = Vector2(size, size)
		selectedPolygon.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		pass
		
	if(selectedPolygon.color == Color(0,0,0,0)):
		updateColor(whiteCol)
	pass

func newPolygonSelected(caller: Area2D):
	var p = caller.get_parent()
	selectedPolygon = p
	emit_signal("OpenUI")
	print("POLY SELECTED")
	pass

func clearSelected():
	selectedPolygon = null
	pass
