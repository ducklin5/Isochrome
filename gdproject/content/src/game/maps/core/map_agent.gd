class_name MapAgent

extends Node

signal teleportation_requested(controller, dest_node)

func request_teleportation(controller, dest_node:Node2D):
	emit_signal("teleportation_requested", controller, dest_node)
