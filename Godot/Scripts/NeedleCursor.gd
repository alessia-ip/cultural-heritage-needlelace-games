extends Sprite2D

# Load the custom images for the mouse cursor.
var needle = load("res://Images/SewingNeedle.png")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	texture = needle;
	
func _process(delta):
	position = get_global_mouse_position()
