tool
extends RigidBody2D

export(Resource) var chroma  setget _set_chroma
export(bool) var is_timed = false
export(float) var duration = 1.0
export(NodePath) var platform_set_path

var is_enabled = false

func _set_chroma(resource):
	if ! (resource is Chroma):
		return
	if has_node("ChromaSprite"):
		$ChromaSprite.modulate = resource.color
		$ChromaSprite.light_mask = resource.light_layer
	chroma = resource

func _ready():
	var _result = $Timer.connect("timeout", self, "close")

func enable():
	get_node(platform_set_path).set_chroma(chroma)
	get_node(platform_set_path).enable()
	is_enabled = true
	
	if is_timed:
		$Timer.wait_time = duration
		$Timer.start()

func disable():
	get_node(platform_set_path).disable()
	is_enabled = false

func _on_InteractArea_triggered(controller):
	var player_chroma = controller.state.get_chroma()
	if player_chroma and player_chroma.name == chroma.name:
		if is_enabled:
			disable()
		else:
			enable()

func _on_Timer_timeout():
	disable()
