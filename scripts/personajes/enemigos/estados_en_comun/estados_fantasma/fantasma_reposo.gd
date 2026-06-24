extends Estado

func entrar():
	enemigo.velocity = Vector2.ZERO
	enemigo.actualizar_animacion("idle")

func actualizar_fisica(_delta):
	if enemigo.jugador:
		var distancia = enemigo.global_position.distance_to(
			enemigo.jugador.global_position
		)

		if distancia < enemigo.distancia_vision:
			transicion.emit("Perseguir")
