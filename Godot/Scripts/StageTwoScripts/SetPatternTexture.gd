extends Sprite2D

func _process(delta: float):	
	var fileExists = FileAccess.file_exists("user://DrawnPattern.png")
	if(fileExists == true):
		var image = Image.load_from_file("user://DrawnPattern.png")
		var t = ImageTexture.create_from_image(image)
		self.texture = t
