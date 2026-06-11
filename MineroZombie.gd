
extends Sprite2D

var tiempo = 0.0

func _process(delta):
	tiempo += delta

	if tiempo > 0.5:
		tiempo = 0.0

		if frame == 0:
			frame = 1
		else:
			frame = 0
