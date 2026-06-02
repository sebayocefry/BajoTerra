extends Node2D


func _ready():
	$AudioStreamPlayer.play()
	$Control/TextureRect.texture = load("res://assets/fondos_intro/cueva1.png")
	
	
	var balloon = DialogueManager.show_dialogue_balloon(
		load("res://DialogosIntro/Dialogo1.dialogue"),
		"start"
	)

	await balloon.tree_exited

	get_tree().change_scene_to_file("res://escenas/UI/intro/intro2.tscn")
	pass
