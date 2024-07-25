extends Node

static func gdclass(node: Node):
	var script: GDScript = node.get_script()
	if script:
		return script.get_class()
	return null

class DictFL:
	static func override(defaults:Dictionary, input:Dictionary) -> Dictionary:
		var dict = defaults
		for key in input:
			dict[key] = input[key]
		return dict
