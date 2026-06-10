extends EstadoJefe

func entrar():
	if enemigo.fase_demonio:
		if animacion.has_animation(enemigo.anim_demonio_movimiento):
			animacion.play(enemigo.anim_demonio_movimiento)
	else:
		if animacion.has_animation(enemigo.anim_movimiento):
			animacion.play(enemigo.anim_movimiento)

	print("Jefe persiguiendo")

func actualizar_fisica(_delta):
	if enemigo.jugador == null:
		transicion.emit("Reposo")
		return

	var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)

	if distancia > enemigo.distancia_vision:
		enemigo.velocity = Vector2.ZERO
		enemigo.move_and_slide()
		transicion.emit("Reposo")
		return

	if enemigo.fase_demonio:
		if enemigo.jugador_en_rango_demonio:
			transicion.emit("FaseDemonio")
			return
	else:
		if enemigo.jugador_en_rango:
			transicion.emit("Atacar")
			return

	var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)

	enemigo.velocity = direccion * enemigo.velocidad

	if direccion.x < 0:
		sprite_chico.flip_h = true
		sprite_demonio.flip_h = true
	elif direccion.x > 0:
		sprite_chico.flip_h = false
		sprite_demonio.flip_h = false

	enemigo.move_and_slide()
