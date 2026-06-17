extends Control

@onready var barra = $TextureProgressB

func _ready():
	if barra == null:
		print("No encontró la barra")
		return

	barra.min_value = 0
	barra.max_value = 100
	barra.value = 100
