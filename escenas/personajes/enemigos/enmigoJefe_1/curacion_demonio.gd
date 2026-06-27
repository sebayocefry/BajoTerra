extends EstadoJefe

@export var duracion_curacion_si_no_hay_animacion : float = 2.0

var activo : bool = false

func entrar():
	activo = true

	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	enemigo.estado_invulnerable = true
	enemigo.curandose = true

	print("Demonio se está curando. Es invulnerable.")

	mirar_jugador()

	if animacion.has_animation(enemigo.anim_demonio_curacion):
		animacion.stop()
		animacion.play(enemigo.anim_demonio_curacion, -1, enemigo.velocidad_anim_curacion)
		await animacion.animation_finished
	else:
		print("No existe animación de curación, usando timer.")
		await get_tree().create_timer(duracion_curacion_si_no_hay_animacion).timeout

	if not activo:
		return

	aplicar_curacion()

	enemigo.estado_invulnerable = false
	enemigo.curandose = false

	print("Curación terminada. El jefe vuelve a recibir daño.")

	transicion.emit("Perseguir")

func aplicar_curacion():
	enemigo.curaciones_usadas += 1

	var nueva_vida = int(enemigo.vida_maxima * enemigo.porcentaje_curacion)

	enemigo.vida = nueva_vida

	print("Jefe demonio se curó a: ", enemigo.vida, "/", enemigo.vida_maxima)
	print("Curaciones usadas: ", enemigo.curaciones_usadas, "/", enemigo.curaciones_maximas)

func mirar_jugador():
	if enemigo.jugador == null:
		return

	var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)

	if direccion.x < 0:
		sprite_demonio.flip_h = false
	elif direccion.x > 0:
		sprite_demonio.flip_h = true

func actualizar_fisica(_delta):
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

func salir():
	activo = false
