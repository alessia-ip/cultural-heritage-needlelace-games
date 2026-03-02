extends Node

@export_category("Stages")
@export var StageZero: Node2D
@export var StageOne: Node2D
@export var StageTwo: Node2D
@export var StageThree: Node2D
@export var StageFour: Node2D
@export var StageFive: Node2D
@export var StageSix: Node2D
@export var StageSeven: Node2D

@export_category("Instructions")
@export var Instructions: Node2D
@export var InstructionText: RichTextLabel

@export_category("Progression")
@export var nextButton: Button
@export var EndingUI: Node2D

@export_category("Hints")
@export var HintZero: Control
@export var HintOne: Control
@export var HintTwo: Control
@export var HintThree: Control
@export var HintFour: Control
@export var HintFive: Control
@export var HintSix: Control
@export var MainUI: Control


var stageInt = 0

signal stageFinished

func _ready():
	nextButton.connect("GoNext", advanceStage)
	HideNextButton()
	enableStage(StageZero)
	
	disableStage(StageOne)
	disableStage(StageTwo)
	disableStage(StageThree)
	disableStage(StageFour)
	disableStage(StageFive)
	disableStage(StageSix)
	disableStage(StageSeven)
	showInstructions()
	
	showHint(HintZero)
	hideHint(HintOne)
	hideHint(HintTwo)
	hideHint(HintThree)
	hideHint(HintFour)
	hideHint(HintFive)
	hideHint(HintSix)
	
	hideEnding()
	
func ShowNextButton():
	nextButton.disabled = false
	nextButton.visible = true
	pass

func HideNextButton():
	nextButton.disabled = true
	nextButton.visible = false
	pass

func incrementStage():
	stageInt = stageInt + 1
	pass
	
func ChangeStage():
	match stageInt:
		1:
			disableStage(StageZero)
			enableStage(StageOne)
			showInstructions()
			InstructionText.text = "Draw the outlines of a design for your lace as a pattern."
			hideHint(HintZero)
			showHint(HintOne)
			pass
		2:
			disableStage(StageOne)
			enableStage(StageTwo)
			showInstructions()
			InstructionText.text = "Use a basting stitch to attach your pattern to fabric."
			hideHint(HintOne)
			showHint(HintTwo)
			pass
		3:
			disableStage(StageTwo)
			enableStage(StageThree)
			showInstructions()
			InstructionText.text = "Create your pattern outlines with stitches."
			hideHint(HintTwo)
			showHint(HintThree)
			pass
		4:
			disableStage(StageThree)
			enableStage(StageFour)
			showInstructions()
			InstructionText.text = "Attach your pattern over the tombolo and cussinello."
			hideHint(HintThree)
			showHint(HintFour)
			pass
		5:
			disableStage(StageFour)
			enableStage(StageFive)
			showInstructions()
			InstructionText.text = "Fill in the areas with lace stitches."
			hideHint(HintFour)
			showHint(HintFive)
			pass
		6:
			disableStage(StageFive)
			enableStage(StageSix)
			showInstructions()
			InstructionText.text = "Remove your lace from pattern."
			hideHint(HintFive)
			showHint(HintSix)
			pass
		7:
			disableStage(StageSix)
			enableStage(StageSeven)
			hideHint(HintSix)
			showEnding()
			pass
	pass

func advanceStage():
	print("Advance to next Stage")
	HideNextButton()
	incrementStage()
	ChangeStage()
	pass
	
func disableStage(stage: Node2D):
	stage.visible = false
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	pass
	
func enableStage(stage: Node2D):
	stage.visible = true
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	stage.connect('stageFinished', ShowNextButton)
	
	pass
	
func disableNoHide(stage: Node2D):
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	pass
	
func showInstructions():
	Instructions.visible = true
	pass

func showHint(hint: Control):
	hint.visible = true
	pass
	
func hideHint(hint: Control):
	hint.visible = false
	pass

func showEnding():
	EndingUI.visible = true
	MainUI.visible = false
	pass

func hideEnding():
	EndingUI.visible = false
	pass
