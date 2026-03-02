extends Polygon2D

var text = load("res://Images/Stitches/Fisso.png")

func _process(delta: float):
	if(Input.is_action_just_pressed("MouseLeft")):
		texture = text
