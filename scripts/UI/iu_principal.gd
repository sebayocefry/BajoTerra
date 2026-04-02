extends Control

"funcion para interactuar con el boton de play"
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file('res://escenas/UI/intro/Intro.tscn')
	
"funcion para interactuar con el boton de creditos"
func _on_creditos_pressed() -> void:
	pass
	
	
"funcion para interactuar con el boton de salir"
func _on_salir_pressed() -> void:
	get_tree().quit()
	

"funcion para iniciar sonido del boton play"
func _on_play_mouse_entered() -> void:
	if not $Boton.playing:
		$Boton.play()
"funcion para salir sonido del boton play"
func _on_play_mouse_exited() -> void:
	$Boton.stop()

"funcion para iniciar sonido del boton Creditos"
func _on_creditos_mouse_entered() -> void:
	if not $Boton.playing:
		$Boton.play()

"funcion para salir sonido del boton Creditos"
func _on_creditos_mouse_exited() -> void:
	$Boton.stop()

"funcion para iniciar sonido del boton Creditos"
func _on_salir_mouse_entered() -> void:
	if not $Boton.playing:
		$Boton.play()

"funcion para salir sonido del boton Creditos"
func _on_salir_mouse_exited() -> void:
	$Boton.stop()
