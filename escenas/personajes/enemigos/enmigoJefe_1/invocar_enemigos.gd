extends EstadoJefe

@export var tiempo_antes_invocar : float = 0.8
@export var tiempo_recuperacion : float = 0.5

var activo : bool = false

func entrar():
	activo = true

	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	print("Demonio usa InvocarEnemigos")

	mirar_jugador()

	if animacion.has_animation(enemigo.anim_demonio_invocacion):
		animacion.stop()
		animacion.play(enemigo.anim_demonio_invocacion)
	else:
		print("No existe la animación de invocación: ", enemigo.anim_demonio_invocacion)

	await get_tree().create_timer(tiempo_antes_invocar).timeout

	if not activo:
		return

	invocar_enemigos()

	await get_tree().create_timer(tiempo_recuperacion).timeout

	if not activo:
		return

	transicion.emit("Perseguir")

func invocar_enemigos():
	if enemigo.escena_enemigo_invocado == null:
		print("ERROR: No hay escena_enemigo_invocado asignada en el inspector.")
		return

	var cantidad = max(enemigo.cantidad_invocados, 1)

	for i in range(cantidad):
		var nuevo_enemigo = enemigo.escena_enemigo_invocado.instantiate()

		var angulo = TAU * float(i) / float(cantidad)
		var offset = Vector2(cos(angulo), sin(angulo)) * enemigo.distancia_invocacion

		nuevo_enemigo.global_position = enemigo.global_position + offset

		get_tree().current_scene.call_deferred("add_child", nuevo_enemigo)

		print("Invocado enemigo en posición: ", nuevo_enemigo.global_position)

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
	print("Salí de InvocarEnemigos")
