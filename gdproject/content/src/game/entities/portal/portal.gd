extends Node2D

export(Resource) var chroma  setget _set_chroma
export(NodePath) var dest_path

func _set_chroma(resource):
	if ! (resource is Chroma):
		return
	if has_node("ChromaSprite"):
		$ChromaSprite.modulate = resource.color
		$ChromaSprite.light_mask = resource.light_layer
	chroma = resource

func _on_InteractArea_triggered(controller):
	var player_chroma = controller.state.get_chroma()
	if player_chroma and player_chroma.name == chroma.name:
		var dest_node = get_node(dest_path)
		if dest_node is Node2D:
			$MapAgent.request_teleportation(controller, dest_node)
