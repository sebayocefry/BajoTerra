extends PointLight2D

@export var energia_min := 1.2
@export var energia_max := 4.0
@export var duracion := 3.0

var tiempo := 0.0

func _process(delta):
	tiempo += delta
	
	# Oscila entre 0 y 1
	var t = (sin((tiempo / duracion) * TAU) + 1.0) / 2.0
	
	# Interpola entre min y max
	energy = lerp(energia_min, energia_max, t)
