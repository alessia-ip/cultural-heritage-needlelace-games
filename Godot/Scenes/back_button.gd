extends TextureButton

@export var SceneManager: Node

func _ready():
	print("button ready")
	connect("pressed", ButtonPressed)
	SceneManager.connect("UPDATE_CAMERASTATE", show_button)
	pass
	
func remove_button():
	visible = false
	disabled = true
	
func show_button(s, n):
	print("showing button")
	visible = true
	disabled = false
	
func ButtonPressed():
	if(SceneManager.currentState != SceneManager.State.STATE_TRANSITION):
		SceneManager.emit_signal("UPDATE_STATE", SceneManager.State.STATE_MAINVIEW)
		remove_button()
	pass
