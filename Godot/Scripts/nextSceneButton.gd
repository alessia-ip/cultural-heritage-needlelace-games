extends Button

signal GoNext

func _pressed():
	print("Next Button Pressed")
	emit_signal("GoNext")
