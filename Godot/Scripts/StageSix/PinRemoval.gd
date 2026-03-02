extends Area2D

var clickable= false

func _process(delta: float):
	if(Input.is_action_just_pressed("MouseLeft") and clickable):
		get_parent().visible = false

func _mouse_enter():
	clickable = true
	
func _mouse_exit():
	clickable=false
