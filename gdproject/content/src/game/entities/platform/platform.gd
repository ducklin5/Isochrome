extends YSort

export var delay = 0.2

func enable():
	for boundary in $Boundaries.get_children():
		boundary.enable()
		$FloorAgent.notify(boundary)
		

	for antiboundary in $AntiBoundaries.get_children():
		antiboundary.disable()
		$FloorAgent.notify(antiboundary)
	
	
	for piece in $Pieces.get_children():
		piece.enable()
		$FloorAgent.notify(piece)
		yield(get_tree().create_timer(delay), "timeout")

func disable():
	for piece in $Pieces.get_children():
		piece.disable()
		$FloorAgent.notify(piece)
		yield(get_tree().create_timer(delay), "timeout")
		
	for boundary in $Boundaries.get_children():
		boundary.disable()
		$FloorAgent.notify(boundary)
		
	for antiboundary in $AntiBoundaries.get_children():
		antiboundary.enable()
		$FloorAgent.notify(antiboundary)

func set_chroma(chroma):
	for piece in $Pieces.get_children():
		piece.chroma = chroma
