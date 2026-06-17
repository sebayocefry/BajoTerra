extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

@export var brillo_min := 0.421
@export var brillo_max := 2.221
@export var duracion := 4.0

var tiempo := 0.0


func _ready():
	if has_node("AnimatedSprite2D"):
		sprite.play("default")


func _process(delta):
	tiempo += delta
	
	# Oscilación suave
	var t = (sin((tiempo / duracion) * TAU) + 1.0) / 2.0
	
	# Intensidad interpolada
	var brillo = lerp(brillo_min, brillo_max, t)
	
	# Cambia brillo/intensidad del sprite
	sprite.modulate = Color.from_hsv(0.38, 0.87, brillo)
