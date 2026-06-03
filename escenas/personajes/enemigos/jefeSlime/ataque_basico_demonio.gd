extends EstadoJefe

@export var tiempo_antes_dano : float = 0.35
@export var tiempo_recuperacion : float = 0.45
@export var margen_extra_dano : float = 20.0

var activo : bool = false

func entrar():
	activo = true

	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	print("Demonio usa AtaqueBasicoDemonio")

	mirar_jugador()

	if animacion.has_animation(enemigo.anim_demonio_ataque):
		animacion.stop()
		animacion.play(enemigo.anim_demonio_ataque)

	await get_tree().create_timer(tiempo_antes_dano).timeout

	if not activo:
		return

	aplicar_dano()

	await get_tree().create_timer(tiempo_recuperacion).timeout

	if not activo:
		return

	transicion.emit("Perseguir")

func aplicar_dano():
	var cuerpos = enemigo.zona_ataque_demonio.get_overlapping_bodies()

	for cuerpo in cuerpos:
		if cuerpo.is_in_group("player"):
			if cuerpo.has_method("recibir_dano"):
				cuerpo.recibir_dano(enemigo.dano_demonio)
				print("Ataque demonio hizo daño usando Zona_ataqueDemonio")
			return

	print("Ataque demonio falló porque el jugador no estaba dentro de Zona_ataqueDemonio")


func mirar_jugador():
	if enemigo.jugador == null:
		return

	var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)

	if direccion.x < 0:
		sprite_demonio.flip_h = false
	elif direccion.x > 0:
		sprite_demonio.flip_h = true

func actualizar_fisica(_delta):
	pass

func salir():
	activo = false
	print("Salí de AtaqueBasicoDemonio")
