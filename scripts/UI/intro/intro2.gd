extends Node2D



func _ready():
	$AudioStreamPlayer.play()
	$Control/TextureRect.texture = load("res://assets/fondos_intro/Bruja.png")

	var balloon = DialogueManager.show_dialogue_balloon(
		load("res://DialogosIntro/Dialogo2.dialogue"),
		"start"
	)
	

	await balloon.tree_exited

	get_tree().change_scene_to_file("res://escenas/niveles/nivel1/habitacion_historia.tscn")
