extends Estado

class_name MukiHuir


@export var velocidad_huida: float = 180.0
@export var distancia_segura: float = 250.0
@export var tiempo_huida: float = 2.5


var tiempo_actual: float = 0.0


func entrar():

	tiempo_actual = tiempo_huida

	enemigo.cambiar_estado_animacion("run")


func actualizar(delta):

	tiempo_actual -= delta
	# SI NO HAY JUGADOR

	if enemigo.jugador == null:

		transicion.emit("MukiReposo")
		return

	# DISTANCIA AL JUGADOR

	var distancia = enemigo.global_position.distance_to(
			enemigo.jugador.global_position
		)

	# SI YA ESTA LEJOS

	if distancia >= distancia_segura:

		transicion.emit("MukiReposo")
		return
		
	# FIN DEL TIEMPO DE HUIDA
	if tiempo_actual <= 0:

		transicion.emit("MukiHostigar")


func actualizar_fisica(delta):

	if enemigo.jugador == null:
		return

	# DIRECCION OPUESTA AL JUGADOR

	var direccion_huida = (
			enemigo.global_position -
			enemigo.jugador.global_position
		).normalized()

	# SEPARACION ENTRE MUKIS

	var separacion = enemigo.calcular_separacion()

	# MOVIMIENTO ERRATICO

	var random_mov = enemigo.obtener_movimiento_random()

	# DIRECCION FINAL

	var direccion_final = (
			direccion_huida +
			separacion +
			random_mov
		).normalized()


	# MOVIMIENTO

	enemigo.velocity = direccion_final * velocidad_huida

	# DIRECCION VISUAL

	enemigo.actualizar_direccion(direccion_final)


	# ANIMACION

	enemigo.cambiar_estado_animacion("run")


	enemigo.move_and_slide()


func salir():

	enemigo.velocity = Vector2.ZERO
