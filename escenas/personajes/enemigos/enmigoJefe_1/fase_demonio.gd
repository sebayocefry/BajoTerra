extends EstadoJefe

@export var tiempo_momento_impacto : float = 0.4843
@export var tiempo_total_ataque : float = 0.56
@export var tiempo_recuperacion : float = 0.5

var activo : bool = false

func entrar():
	activo = true

	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	print("Jefe atacando en fase demonio")

	mirar_jugador()

	if animacion.has_animation(enemigo.anim_demonio_ataque):
		animacion.stop()
		animacion.play(enemigo.anim_demonio_ataque)
	else:
		print("No existe animación demonio ataque")

	await get_tree().create_timer(tiempo_momento_impacto).timeout

	if not activo:
		return

	aplicar_dano_si_sigue_en_rango()

	var tiempo_restante = max(tiempo_total_ataque - tiempo_momento_impacto, 0.0)

	await get_tree().create_timer(tiempo_restante).timeout

	if not activo:
		return

	await get_tree().create_timer(tiempo_recuperacion).timeout

	if not activo:
		return

	transicion.emit("Perseguir")

func aplicar_dano_si_sigue_en_rango():
	var cuerpos = enemigo.zona_ataque_demonio.get_overlapping_bodies()

	for cuerpo in cuerpos:
		if cuerpo.is_in_group("player"):
			if cuerpo.has_method("recibir_dano"):
				cuerpo.recibir_dano(enemigo.dano_demonio)
				print("Ataque demonio hizo daño en el segundo configurado")
			return

	print("Ataque demonio falló porque el jugador salió del rango antes del impacto")

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
	print("Salí de FaseDemonio")
