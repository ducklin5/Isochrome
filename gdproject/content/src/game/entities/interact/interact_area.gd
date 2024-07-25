tool
class_name InteractArea
extends Area2D

signal activated
signal deactivated
signal triggered(controller)

const IndicatorScene = preload("res://content/src/game/entities/interact/indicator.tscn")
export(Vector2) var indicator_position = Vector2(0,-16)
var indicator = null

func _ready():
	collision_layer = 16
	collision_mask = 16
	indicator = IndicatorScene.instance()
	indicator.position = indicator_position
	indicator.hide()
	add_child(indicator)

func get_floor(node: Node2D):
	var parent = node.get_parent()
	while !(parent.get_class() == "Floor" || parent is Viewport):
		parent = parent.get_parent()
	return parent if parent.get_class() == "Floor" else null

func activate(controller):
	if get_floor(controller.state.actor) == get_floor(self):
		indicator.show()
		indicator.start()
		emit_signal("activated")
		return true
	return false

func deactivate(controller):
	if get_floor(controller.state.actor) == get_floor(self):
		indicator.hide()
		indicator.stop()
		emit_signal("deactivated")
		return true
	return false



func trigger(controller):
	if get_floor(controller.state.actor) == get_floor(self):
		emit_signal("triggered", controller)
