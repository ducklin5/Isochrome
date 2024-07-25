class_name PlayerController
extends Controller

var FTUE_HUDScene = "res://content/src/game/hud/ftue_hud.tscn"

var state: PlayerState
var actor: Actor
var camera: Camera2D
var hud

var camera_follow = true
var disable_input = false
var disabled_events = []

var pressed_actions = []

var interactable = null

signal teleportation_requested(dest_node)
signal transition_requested(next_map)

func _init(state: PlayerState, camera: Camera2D, ftue: bool):
	self.state = state
	self.actor = state.actor
	self.camera = camera
	camera.zoom = Vector2(0.4,0.4)
	camera.position = actor.position
	
	actor.connect("dead", self, "stop_following")
	actor.connect("alive", self, "start_following")
	actor.connect("interactable_entered", self, "_set_interactable")
	actor.connect("interactable_exited" , self, "_remove_interactable")
	
	if ftue:
		hud = load(FTUE_HUDScene).instance()
		add_child(hud)

func _process(delta):
	if camera_follow:
		camera.global_position = actor.global_position
	for action in pressed_actions:
		if !Input.is_action_pressed(action):
			pressed_actions.erase(action)
			_on_action_released(action)
	
	var mouse_vec = actor.get_local_mouse_position()
	var mouse_angle = mouse_vec.angle()
	actor.aim(mouse_angle)
	
func is_pressed_action(event, action):
	if event.is_action(action):
		if event.is_pressed() and !event.is_echo():
			pressed_actions.append(action)
			return true
	return false

func _unhandled_input(event):
	if disable_input:
		disabled_events.append(event)
		return
		
	if is_pressed_action(event, "move_up"):
		actor.input_dir(Actor.Direction.UP)
	elif is_pressed_action(event, "move_down"):
		actor.input_dir(Actor.Direction.DOWN)
	elif is_pressed_action(event, "move_left"):
		actor.input_dir(Actor.Direction.LEFT)
	elif is_pressed_action(event, "move_right"):
		actor.input_dir(Actor.Direction.RIGHT)
	elif is_pressed_action(event, "ui_accept"):
		actor.try_ability()
	elif is_pressed_action(event, "interact"):
		if interactable != null:
			interactable.trigger(self)

func _on_action_released(action):
	match action:
		"move_up":
			actor.release_dir(Actor.Direction.UP)
		"move_down":
			actor.release_dir(Actor.Direction.DOWN)
		"move_left":
			actor.release_dir(Actor.Direction.LEFT)
		"move_right":
			actor.release_dir(Actor.Direction.RIGHT)

func _set_interactable(item):
	if item.activate(self):
		if interactable:
			interactable.deactivate(self)
		interactable = item

func _remove_interactable(item):
	if item.deactivate(self):
		if interactable == item:
			interactable = null

func stop_following():
	camera_follow = false
	disable_input = true
	disabled_events = []

func start_following():
	var tween = Tween.new()
	tween.interpolate_property(camera, "global_position",
		camera.global_position, actor.global_position, 1.0,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	add_child(tween)
	tween.connect("tween_all_completed", self, "_camera_tween_finished", [tween])
	tween.start()

func _camera_tween_finished(tween):
	camera_follow = true
	disable_input = false
	for event in disabled_events:
		_unhandled_input(event)
	disabled_events = []
	tween.queue_free()

func request_transition(next_map):
	emit_signal("transition_requested", next_map)

func disable_ftue():
	if hud:
		hud.hide()
