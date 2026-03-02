extends Button


func _ready() -> void:
	connect("button_down", restart)

func restart():
	print("restartrestart")
	get_tree().reload_current_scene()
