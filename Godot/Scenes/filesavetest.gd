extends Node2D

func _ready() -> void:
	var Desktop = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	var username
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	elif OS.has_environment("username"):
		username = OS.get_environment("username")
	elif OS.has_environment("Username"):
		username = OS.get_environment("Username")
	elif OS.has_environment("user"):
		username = OS.get_environment("user")
	elif OS.has_environment("User"):
		username = OS.get_environment("User")
	elif OS.has_environment("USER"):
		username = OS.get_environment("USER")
	else:
		username = "Player"
	print(username)
	var folder = username + "_Lace_Creations"
	if (DirAccess.dir_exists_absolute(Desktop + "/" + folder)):
		print("exists")
	else:
		print("does not exist")
		var dir = DirAccess.open(Desktop)
		dir.make_dir(folder)  
	var img = get_viewport().get_texture().get_image()
	var fileName = str(Time.get_datetime_string_from_system().replace(":", "_")) + "_Lace_Creation"
	var path = Desktop + "/" + folder + "/" + fileName + ".png"
	print(path)
	img.save_png(path)
