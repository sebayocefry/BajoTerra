extends EstadoJefe

func entrar():
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	if enemigo.fase_demonio:
		if animacion.has_animation(enemigo.anim_demonio_reposo):
			animacion.play(enemigo.anim_demonio_reposo)
	else:
		if animacion.has_animation(enemigo.anim_reposo):
			animacion.play(enemigo.anim_reposo)

	print("Jefe en Reposo")

func actualizar_fisica(_delta):
	if enemigo.jugador == null:
		enemigo.jugador = get_tree().get_first_node_in_group("player")
		return

	var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)

	if distancia <= enemigo.distancia_vision:
		transicion.emit("Perseguir")
