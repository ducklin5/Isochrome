class_name Totem
extends Actor

onready var smp = $StateMachinePlayer

export(float) var speed = 90

var direction = Vector2(0,0)
var iso_direction = Vector2(0,0)
var aim_angle = 0
var ability_angle = 0
var is_ready = false
var chroma:Chroma setget set_chroma
var should_check_floor = true

signal dead
signal alive
signal interactable_entered(area)
signal interactable_exited(body)

func _ready():
	set_chroma(chroma)
	is_ready = true

func unload():
	if get_parent():
		get_parent().remove_child(self)
		var should_check_floor = false
		smp.set_param("on_ground", true)
	

func reset():
	if is_ready:
		$AnimationPlayer.seek(0.0,true)
		emit_signal("alive")
		smp.restart()

func aim(angle):
	aim_angle = angle
	$Sprites/Aim.rotation = angle + PI/2
	$Sprites/Aim.position.y = -3.9 if angle > 0 else -4.1
	$Sprites/Aim.z_index = 1 if angle > 0 else 0

func input_dir(dir):
	
	match dir:
		Direction.UP:
			direction += Vector2.UP
		Direction.DOWN:
			direction += Vector2.DOWN
		Direction.LEFT:
			direction += Vector2.LEFT
		Direction.RIGHT:
			direction += Vector2.RIGHT
	_update_dir()

func release_dir(dir):
	match dir:
		Direction.UP:
			direction -= Vector2.UP
		Direction.DOWN:
			direction -= Vector2.DOWN
		Direction.LEFT:
			direction -= Vector2.LEFT
		Direction.RIGHT:
			direction -= Vector2.RIGHT
	_update_dir()

func set_chroma(resource):
	if ! (resource is Chroma):
		return
	if $AreaLight and $BodyLight and $ChromaLight:
		$Sprites.modulate = resource.color
		$BodyLight.color = resource.color
		$ChromaLight.range_item_cull_mask = resource.light_layer
	chroma = resource

func try_ability():
	smp.set_trigger("ability")

func check_floor():
	var bodies = $GroundArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("ground"):
			return true
	return false

func _update_dir():
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)
	
	var unit_dir = direction.normalized()
	var iso_tranform = Transform2D(Vector2(1.2649, 0), Vector2(0, 0.6325), Vector2(0,0))
	var iso_vec = iso_tranform.basis_xform(unit_dir)
	iso_direction = iso_vec.normalized()

func _physics_process(_delta):
	smp.set_param("walk", iso_direction.length_squared() > 0)
	if should_check_floor:
		smp.set_param("on_ground", check_floor())

func _on_StateMachinePlayer_transited(from, to):
	match to:
		"Ability":
			collision_mask &= ~4
			ability_angle = aim_angle
			smp.set_param("ability_time", 0)
	
	match from:
		"Ability":
			collision_mask |= 4

func _on_StateMachinePlayer_updated(state, delta):
	match state:
		"Idle":
			pass
		"Walk":
			var vel =  iso_direction * speed
			move_and_slide(vel)
		"Ability":
			var dir =  Vector2.RIGHT.rotated(ability_angle)
			var vel =  dir * speed * 2
			move_and_collide(vel*delta)
			
			var ability_time = smp.get_param("ability_time")
			smp.set_param("ability_time", ability_time + delta)
	$AnimComponent._update_anim(state)

func _on_InteractionArea_area_entered(area):
	if area is InteractArea:
		emit_signal("interactable_entered", area)

func _on_InteractionArea_area_exited(area):
	if area is InteractArea:
		emit_signal("interactable_exited", area)

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Fall":
			emit_signal("dead")
