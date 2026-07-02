extends EstadoJefe

@export_group("Ataque 1")
@export var tiempo_impacto_ataque_1 : float = 0.4843
@export var tiempo_total_ataque_1 : float = 0.56

@export_group("Ataque 2")
@export var tiempo_impacto_ataque_2 : float = 0.3
@export var tiempo_total_ataque_2 : float = 0.3466

@export_group("General")
@export var tiempo_recuperacion : float = 0.7

var activo : bool = false
var siguiente_ataque : int = 1

func entrar():
	activo = true

	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	mirar_jugador()

	var animacion_elegida : String
	var tiempo_impacto : float
	var tiempo_total : float

	if siguiente_ataque == 1:
		animacion_elegida = enemigo.anim_demonio_ataque
		tiempo_impacto = tiempo_impacto_ataque_1
		tiempo_total = tiempo_total_ataque_1
		siguiente_ataque = 2
		print("Demonio usa ataque 1")
	else:
		animacion_elegida = enemigo.anim_demonio_ataque_2
		tiempo_impacto = tiempo_impacto_ataque_2
		tiempo_total = tiempo_total_ataque_2
		siguiente_ataque = 1
		print("Demonio usa ataque 2")

	if animacion.has_animation(animacion_elegida):
		animacion.stop()
		animacion.play(animacion_elegida)
	else:
		print("No existe la animación: ", animacion_elegida)

	await get_tree().create_timer(tiempo_impacto).timeout

	if not activo:
		return

	aplicar_dano_si_sigue_en_rango()

	var tiempo_restante = max(tiempo_total - tiempo_impacto, 0.0)

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
				print("Ataque demonio hizo daño en el momento configurado")
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
