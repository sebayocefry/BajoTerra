extends EstadoJefe

func entrar():
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	print("Jefe transformándose")

	if animacion.has_animation(enemigo.anim_transformacion):
		animacion.play(enemigo.anim_transformacion, -1, enemigo.velocidad_anim_transformacion)
		await animacion.animation_finished

	enemigo.activar_forma_demonio()

	enemigo.vida_maxima = enemigo.vida_fase_demonio
	enemigo.vida = enemigo.vida_fase_demonio

	enemigo.estado_invulnerable = false
	enemigo.transformandose = false

	print("Jefe terminó transformación. Vida demonio: ", enemigo.vida)

	transicion.emit("Reposo")

func actualizar_fisica(_delta):
	pass
