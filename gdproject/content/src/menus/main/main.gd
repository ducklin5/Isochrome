extends Control

var game_scene_path = "res://content/src/game/core/game.tscn"
export(Array, Resource) var chroma_to_demo: Array = []

func _ready():
	randomize()
	change_chroma()

func change_chroma():
	var chroma = chroma_to_demo[randi() % chroma_to_demo.size()]
	$VBox/Body/VBox/Title.modulate = chroma.color
	$VBox/Body/VBox/ChromaDemo.set_chroma(chroma)

func _on_Play_pressed():
	var game = load(game_scene_path).instance()
	game.set_up()
	Global.set_scene(game)

func _on_HowTo_pressed():
	var game = load(game_scene_path).instance()
	game.set_up(true)
	Global.set_scene(game)
