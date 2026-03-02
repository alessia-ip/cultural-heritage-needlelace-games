extends Area2D

var isTheTarget: bool = false

func _mouse_enter():
	isTheTarget = true
	pass
	
func _mouse_exit():
	isTheTarget = false
	pass

func _process(delta):
	if(Input.is_action_just_pressed("MouseLeft") and isTheTarget):
		get_parent().get_parent().visible = false
		pass
	pass
