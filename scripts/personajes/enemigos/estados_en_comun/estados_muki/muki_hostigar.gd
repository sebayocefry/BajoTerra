extends Estado

class_name MukiHostigar


@export var distancia_ataque: float = 120.0
@export var velocidad_hostigamiento: float = 120.0


func entrar():

	enemigo.cambiar_estado_animacion("run")


func actualizar(delta):
	
	print("ENTRO A HOSTIGAR")

	if enemigo.jugador == null:

		transicion.emit("MukiReposo")
		return


	var distancia = enemigo.global_position.distance_to(
			enemigo.jugador.global_position
		)

	# Entrar a atacar
	if distancia <= distancia_ataque:
		
		print("ATACANDO")

		transicion.emit("MukiAtacar")
		return


func actualizar_fisica(delta):

	if enemigo.jugador == null:
		return

	# OBJETIVO SWARM

	var objetivo = enemigo.obtener_posicion_hostigamiento()

	# DIRECCION HACIA OBJETIVO

	var direccion = (objetivo - enemigo.global_position).normalized()


	# SEPARACION ENTRE mmukis

	var separacion = enemigo.calcular_separacion()

	# MOVIMIENTO ERRATICO

	var random_mov = enemigo.obtener_movimiento_random()

	# DIRECCION FINAL SWARM

	var direccion_final = (
			direccion +
			separacion +
			random_mov
		).normalized()

	# MOVIMIENTO

	enemigo.velocity = direccion_final * velocidad_hostigamiento

	# DIRECCON Visual

	if direccion_final.length() > 0.1:
		enemigo.actualizar_direccion(direccion_final)

	# ANIMACION

	if enemigo.velocity.length() > 10:

		enemigo.cambiar_estado_animacion("run")

	else:

		enemigo.cambiar_estado_animacion("walk")


	enemigo.move_and_slide()


func salir():

	enemigo.velocity = Vector2.ZERO
