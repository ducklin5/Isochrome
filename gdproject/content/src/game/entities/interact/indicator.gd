extends Sprite

export(float) var period = 0.3
export(float) var radius = 4.0

var time = 0
var running = false

func start():
	running = true
func stop():
	running = false

func _process(delta):
	time += delta
	if running:
		offset.y = radius * sin(time/period)
		$Light2D.offset = offset
