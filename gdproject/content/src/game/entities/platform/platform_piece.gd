tool
class_name PlatformPiece
extends RigidBody2D

export(Resource) var chroma  setget _set_chroma
export var is_enabled = false setget set_enabled

func _ready():
	set_enabled(is_enabled)

func _set_chroma(resource):
	if ! (resource is Chroma):
		return
	$Sprites/ChromaSprite.modulate = resource.color
	$Sprites/ChromaSprite.light_mask = resource.light_layer
	chroma = resource

func enable():
	#if !$Sprites.visible:
	is_enabled = true
	$Sprites.visible = true
	collision_layer = 2
	collision_mask = 2
	$AnimationPlayer.play("enable")

func disable():
	#if $Sprites.visible:
	is_enabled = false
	collision_layer = 0
	collision_mask = 0
	$AnimationPlayer.play("disable")
		

func set_enabled(enabled):
	if enabled:
		enable()
	else:
		disable()
