extends Estado

class_name MukiAtacar


@export var duracion_ataque: float = 0.8

var atacando := false


func entrar():

	atacando = true

	enemigo.velocity = Vector2.ZERO

	# VALIDAR

	if enemigo.jugador == null:
		return

	# DIRECCION

	var direccion = (
		enemigo.jugador.global_position -
		enemigo.global_position
	).normalized()

	enemigo.actualizar_direccion(direccion)

	# ANIMACION

	enemigo.cambiar_estado_animacion("attack")

	# HACER el daño inmmediato

	print("MUKI GOLPEA")


	enemigo.jugador.recibir_dano(

		enemigo.dano_muki,

		(
			enemigo.jugador.global_position -
			enemigo.global_position
		).normalized() * 250
	)

	# ESPERAR FIN ATAQUE

	await enemigo.get_tree().create_timer(
		duracion_ataque
	).timeout

	# VALIDAR

	if enemigo == null:
		return

	# VOLVER

	if enemigo.jugador_en_rango:
		transicion.emit("MukiHostigar")
	else:
		transicion.emit("MukiReposo")


func actualizar(delta):

	pass


func actualizar_fisica(delta):

	enemigo.velocity = Vector2.ZERO


func salir():

	atacando = false
