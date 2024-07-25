extends CanvasLayer

signal _wait_done

func _ready():
	describe_controls()

func hide():
	for child in get_children():
		child.hide()

func describe_controls():
	show_text("Hello Hue.. have you forgotten the rules again?")
	yield(wait(6.0), "completed")
	show_text("Alright here is the deal..")
	yield(wait(6.0), "completed")
	show_text("You must find your way to the gate") 
	show_image("res://assets/game/maps/gate.png")
	yield(wait(6.0), "completed")
	show_text("Find the source of these chroma and bring it back to our world.") 
	show_image("res://assets/game/items/orb.png")
	yield(wait(6.0), "completed")
	show_text("These are your movement controls...")
	show_image("res://assets/ui/movement_keys.png")
	yield(wait(6.0), "completed")
	show_text("This is your jump ability. Use it wisely..")
	show_image("res://assets/ui/space_key.png")
	yield(wait(6.0), "completed")
	show_text("This will also come in handy..")
	show_image("res://assets/ui/interact_key.png")
	yield(wait(6.0), "completed")
	show_text("Remember, you can only use one chroma at a time...")
	show_image("res://assets/game/items/orb.png")
	yield(wait(6.0), "completed")
	show_text("And the gates only work for those with the right chroma.")
	show_image("res://assets/game/maps/gate.png")
	yield(wait(6.0), "completed")
	show_text("Good Luck!")
	show_image("res://assets/game/maps/gate.png")

func show_text(text):
	$info_panel/HBoxContainer/RichTextLabel.text = text

func show_image(texture_path):
	$info_panel/HBoxContainer/Panel/TextureRect.texture = load(texture_path)

func clear_image():
	$info_panel/HBoxContainer/Panel/TextureRect.texture = null

func wait(duration):
	if get_tree():
		var timer = get_tree().create_timer(duration)
		timer.connect("timeout",self,"emit_signal", ["_wait_done"])
		yield(self, "_wait_done")
		timer.disconnect("timeout",self,"emit_signal")

func _on_ClickArea_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("_wait_done")

