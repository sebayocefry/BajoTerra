extends Estado

class_name MukiHurt


@export var tiempo_hurt: float = 0.4
@export var fuerza_retroceso: float = 140.0


var direccion_golpe: Vector2 = Vector2.ZERO


func entrar():

	
	# ANIMACION

	enemigo.cambiar_estado_animacion("hurt")

	# RETROCESO DESDE EL JUGADOR

	if enemigo.jugador != null:

		direccion_golpe = (
				enemigo.global_position -
				enemigo.jugador.global_position
			).normalized()

		enemigo.actualizar_direccion(direccion_golpe)

	# Timer del hurt

	await enemigo.get_tree().create_timer(tiempo_hurt).timeout

	# VALIDACION

	if enemigo == null:
		return

	# Si muere

	if enemigo.vida <= 0:

		enemigo.morir()
		return

	# VOLVER A HOSTIGAR

	transicion.emit("MukiHostigar")


func actualizar(delta):

	pass


func actualizar_fisica(delta):

	# REtroceso

	enemigo.velocity = direccion_golpe * fuerza_retroceso


	enemigo.move_and_slide()


func salir():

	enemigo.velocity = Vector2.ZERO
