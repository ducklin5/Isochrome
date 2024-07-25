extends RigidBody2D

export(Resource) var chroma  setget set_chroma
export(PackedScene) var next_map

func set_chroma(resource):
	if ! (resource is Chroma):
		return
	$BodyLight.color = resource.color
	$Sprite.modulate = resource.color
	chroma = resource

func _ready():
	set_chroma(chroma)

func _on_InteractArea_activated():
	pass # Replace with function body.

func _on_InteractArea_deactivated():
	pass # Replace with function body.

func _on_InteractArea_triggered(controller):
	if controller.state.get_chroma() == chroma:
		controller.request_transition(next_map)
