extends Button

@export var topParent: Node2D

func _ready():
	pressed.connect(snip)
	pass
	
func snip():
	print("snip")
	var lines = topParent.get_children(true)
	print(lines)
	for line in lines:
		var childNum = line.get_child_count()
		if childNum > 0:
			var newchildren = line.get_children()
			for nC in newchildren:
				lines.append(nC)
		if(line is Line2D):
			if line.has_meta("Type"):
				var metaVal = line.get_meta("Type")
				print(metaVal)
				if(metaVal == "Basting"):
					line.visible = false
			pass
	visible = false	
	pass
