class_name Map
extends Node2D

var agents = []
var current_floor = 0 setget set_current_floor, get_current_floor
export var spawn_floor = 0

func _ready():
	_register_agents(self)
	set_current_floor(current_floor)

func _register_agents(node):
	if node is MapAgent:
		agents.append(node)
		node.connect("teleportation_requested", self, "handle_teleportation_request" )
	for child in node.get_children():
		_register_agents(child)



func set_current_floor_by_node(node, animate = true):
	var path = get_path_to(node)
	var path_root = path.get_name(0)
	var root_node = get_node_or_null(path_root)
	if root_node and root_node.get_parent() == self:
		if root_node.get_class() == "Floor":
			var floors = get_all_floors()
			var idx = floors.find(root_node)
			set_current_floor(idx, animate)

func set_current_floor(target_idx, animate = false):
	var floors = get_all_floors()
	
	for i in floors.size():
		floors[i].z_index = i
		floors[i].disable_collision()

	for i in range(0, target_idx):
		var brightness = pow(max(1 + (i - target_idx) / 3.0, 0), 4.0)
		
		var new_color = Color.from_hsv(0,0,brightness)
		floors[i].show()
		
		_set_floor_modulate(floors[i], new_color, {
			"hide": brightness == 0
		})
	
	floors[target_idx].enable_collision()
	floors[target_idx].show()
	_set_floor_modulate(floors[target_idx], Color.white)
	
	for i in range(target_idx+1, floors.size()):
		floors[i].hide()
	
	current_floor = target_idx

func _set_floor_modulate(floor_node: Floor, target_color, animate = false, params = {}):
	params = Util.DictFL.override({
		"duration": 1.0,
		"hide": false
	}, params);
	
	if !animate:
		floor_node.modulate = target_color
		if params["hide"]:
			floor_node.hide()
	else:
		var tween = Tween.new()
		tween.interpolate_property(
			floor_node, "modulate", 
			floor_node.modulate, target_color, params["duration"],
			tween.TRANS_LINEAR,Tween.EASE_IN_OUT
		)
		add_child(tween)
		tween.connect("tween_all_completed", self, "_on_tween_floor_modulated",
			[tween, floor_node, params["hide"]]
		)
		tween.start()

func _on_tween_floor_modulated(tween, floor_node, hide):
	remove_child(tween)
	tween.queue_free()
	
	if hide:
		floor_node.hide()
	
func get_current_floor():
	return current_floor

func get_all_floors():
	var floors = []
	for child in get_children():
		if child.get_class() == "Floor":
			floors.append(child)
	return floors

func get_floor(idx):
	var floors = get_all_floors()
	return floors[idx]

func spawn_actor(actor: Actor, dest_node: Node):
	assert(is_a_parent_of(dest_node))
	actor.unload()
	actor.position = dest_node.position
	dest_node.get_parent().add_child(actor)
	actor.reset()
	set_current_floor_by_node(actor)

func spawn_actor_at_start(actor):
	var startpoint = get_floor(spawn_floor).get_spawn()
	spawn_actor(actor, startpoint)

func handle_teleportation_request(controller: Controller, dest_node):
	controller.stop_following()
	spawn_actor(controller.actor, dest_node)
	controller.start_following()


