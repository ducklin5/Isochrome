extends Node

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func set_scene(node:Node):
	call_deferred("_deferred_set_scene", node)

func _deferred_set_scene(node:Node):
	current_scene.free()
	get_tree().get_root().add_child(node)
	get_tree().set_current_scene(node) 
	current_scene = node
