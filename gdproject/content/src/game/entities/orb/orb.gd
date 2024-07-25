tool
extends Node2D

export(Resource) var chroma  setget set_chroma

func set_chroma(resource):
	if ! (resource is Chroma):
		return
	if has_node("AreaLight") and has_node("BodyLight"):
		$AreaLight.color = resource.color
		$BodyLight.color = resource.color
		$Sprite.modulate = resource.color
	chroma = resource

func _ready():
	set_chroma(chroma)

func deactivate():
	$InteractArea/CollisionShape2D.disabled = true
	$AreaLight.visible = false
	$BodyLight.visible = false

func _on_InteractArea_triggered(controller):
	controller.state.set_chroma(chroma)
	

func _on_InteractArea_activated():
	pass # Replace with function body.

func _on_InteractArea_deactivated():
	pass # Replace with function body.
