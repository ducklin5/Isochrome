tool
extends RigidBody2D

export(Resource) var chroma  setget _set_chroma
export(bool) var is_timed = false
export(float) var duration = 1.0


var opened_texture = preload("res://assets/game/maps/door_open.png")
var closed_texture = preload("res://assets/game/maps/door.png")

var is_open = false

func _set_chroma(resource):
	if ! (resource is Chroma):
		return
	if has_node("ChromaSprite"):
		$ChromaSprite.modulate = resource.color
		$ChromaSprite.light_mask = resource.light_layer
	chroma = resource

func _ready():
	var _result = $Timer.connect("timeout", self, "close")

func open():
	$BaseSprite.texture = opened_texture
	$ChromaSprite.texture = opened_texture
	$CollisionPolygon2D.disabled = true
	is_open = true
	if is_timed:
		$Timer.wait_time = duration
		$Timer.start()

func close():
	$BaseSprite.texture = closed_texture
	$ChromaSprite.texture = closed_texture
	$CollisionPolygon2D.disabled = false
	is_open = false



func _on_InteractArea_triggered(controller):
	var player_chroma = controller.state.get_chroma()
	if player_chroma and player_chroma.name == chroma.name:
		if is_open:
			close()
		else:
			open()
