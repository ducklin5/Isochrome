tool
extends VBoxContainer

func set_chroma(chroma):
	$ViewportContainer/Viewport/Gate.set_chroma(chroma)
	$Label.text = chroma.name
	$Label.modulate = chroma.color
