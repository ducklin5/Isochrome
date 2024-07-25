extends Node
class_name Game

const PlayerActorScene = preload("res://content/src/game/entities/actors/characters/totem/totem.tscn")
# {{ player info
var player_controller :Controller
var player_state :PlayerState
# }}

# {{ Viewport and Map
var viewport :Viewport
var camera :Camera2D
var map: Map
# spwanPoints
var spawn: Position2D
# }}

# {{ signals
signal tick(time, latency)
# }}

func set_up(ftue = false):
	set_up_viewport()
	var InitMapScene = load("res://content/src/game/maps/gym3.tscn")
	var FTUEMapScene = load("res://content/src/game/maps/Tutorial.tscn")
	if ftue:
		set_up_map(FTUEMapScene)
	else:
		set_up_map(InitMapScene)
	set_up_player(ftue)

func set_up_viewport():
	var container = ViewportContainer.new()  
	container.stretch = true
	container.set_anchors_and_margins_preset(Control.PRESET_WIDE)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	viewport = Viewport.new()
	camera = Camera2D.new()
	camera.current = true
	container.name = "ViewportContainer"
	viewport.name = "Viewport"
	camera.name = "Camera2D"
	viewport.add_child(camera)
	container.add_child(viewport)
	add_child(container)

func set_up_map(map_scene):
	map = map_scene.instance()
	viewport.add_child(map)

func set_up_player(ftue):
	var player_actor = PlayerActorScene.instance()
	player_actor.connect("dead", self, "respawn", [player_actor])
	
	map.spawn_actor_at_start(player_actor)
	
	player_state = PlayerState.new(player_actor)
	add_child(player_state)
	
	player_controller = PlayerController.new(player_state, camera, ftue)
	player_controller.connect("teleportation_requested", self, "handle_teleportation_request", [player_controller])
	player_controller.connect("transition_requested", self, "handle_transition_request", [player_controller])
	add_child(player_controller)

func respawn(actor):
	actor.unload()
	map.spawn_actor_at_start(actor) 
	map.set_current_floor_by_node(actor)
	actor.reset()

func handle_transition_request(next_map_scene, controller: Controller):
	if next_map_scene:
		player_state.set_chroma(null)
		controller.actor.unload()
		controller.disable_ftue()
		viewport.remove_child(map)
		map = next_map_scene.instance()
		viewport.add_child(map)
		map.spawn_actor_at_start(controller.actor)
		
