extends Node

var last_direction = Vector2.DOWN

# parent variables
var host = null setget set_host

var direction_names = {
		Vector2.UP: "N",
		Vector2.UP + Vector2.RIGHT: "NE",
		Vector2.UP + Vector2.LEFT: "NW",
		Vector2.DOWN: "S",
		Vector2.DOWN + Vector2.RIGHT: "SE",
		Vector2.DOWN + Vector2.LEFT: "SW",
		Vector2.LEFT: "W",
		Vector2.RIGHT: "E",
		Vector2.ZERO: "S"
	}

var octant_names = {
	0: "E",
	1: "SE",
	2: "S",
	3: "SW",
	4: "W",
	-1: "NE",
	-2: "N",
	-3: "NW",
	-4: "W",
}

func set_host(target):
	if host == null:
		return target
	else:
		print("Setting host is not allowed")

func _ready():
	host = get_parent()

func _update_anim(state):
	
	_update_head_anim(state)
	
	match state:
		"Idle":
			var anim_to_play = "Idle_" + direction_names[last_direction]
			$"../Sprites/BodySprite".play(anim_to_play)
		"Walk":
			var anim_to_play = "Walk_" + direction_names[host.direction]
			$"../Sprites/BodySprite".play(anim_to_play)
			last_direction = host.direction
		"Fall":
			$"../AnimationPlayer".play("Fall")
		"Ability":
			var ability_direction = Vector2.RIGHT.rotated(host.ability_angle)
			var octant = int(round(ability_direction.angle() * 4/PI))
			var body_anim_to_play = "Walk_" + octant_names[octant]
			var head_anim_to_play = "Stationary_" + octant_names[octant]
			$"../Sprites/BodySprite".play(body_anim_to_play)
			$"../Sprites/HeadSprite".play(head_anim_to_play)
	

func _update_head_anim(state):
	var aim_direction = Vector2.RIGHT.rotated(host.aim_angle)
	var lower_look_bound = last_direction.rotated(-PI/4)
	var upper_look_bound = last_direction.rotated(PI/4)
	
	var look_direction = last_direction
	
	var upper_angle = abs(aim_direction.angle_to(upper_look_bound))
	var lower_angle = abs(aim_direction.angle_to(lower_look_bound))
	
	if upper_angle > PI/2 or lower_angle > PI/2: #outside sector
		if upper_angle > lower_angle:
			look_direction = lower_look_bound
		else:
			look_direction = upper_look_bound
	
	var octant = int(round(look_direction.angle() * 4/PI))
	
	$"../Sprites/HeadSprite".play("Stationary_"+ octant_names[octant])
