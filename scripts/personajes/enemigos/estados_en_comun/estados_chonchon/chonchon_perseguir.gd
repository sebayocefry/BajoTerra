extends Estado


func entrar():
	enemigo.actualizar_animacion("run")


func actualizar_fisica(_delta):
	if not enemigo.jugador:
		return

	# SI EL JUGADOR ENTRA AL RANGO
	if enemigo.jugador_en_rango:
		enemigo.velocity = Vector2.ZERO
		enemigo.move_and_slide()
		transicion.emit("Atacar")
		return

	# DIRECCIÓN HACIA JUGADOR
	var direccion = enemigo.global_position.direction_to(
		enemigo.jugador.global_position
	)

	# ACTUALIZAR DIRECCIÓN VISUAL
	enemigo.actualizar_direccion(direccion)

	# ANIMACIÓN
	enemigo.actualizar_animacion("run")

	# MOVIMIENTO
	enemigo.velocity = direccion * enemigo.velocidad

	enemigo.move_and_slide()
