tool
class_name Chroma
extends Resource

export(String) var name
export(Color) var color
export(int, LAYERS_2D_RENDER) var light_layer

func _init(p_name="", p_color=Color(0,0,0), p_light_layer=0):
	name = p_name
	color = p_color
	light_layer = p_light_layer
