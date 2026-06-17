extends Node

func _ready():
	await get_tree().create_timer(1.0).timeout
	var image = get_viewport().get_texture().get_image()
	image.save_png("res://screenshot.png")
	get_tree().quit()
