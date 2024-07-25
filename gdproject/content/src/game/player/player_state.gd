class_name PlayerState
extends Node

var actor: Actor

func _init(actor: Actor):
	self.actor = actor

func _ready():
	pass

func set_chroma(chroma):
	actor.set_chroma(chroma)

func get_chroma():
	return actor.chroma
