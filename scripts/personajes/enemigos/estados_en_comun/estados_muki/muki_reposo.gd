extends Estado

class_name MukiReposo


@export var tiempo_reposo: float = 1.5

var tiempo_actual: float = 0.0


func entrar():

	tiempo_actual = tiempo_reposo

	enemigo.velocity = Vector2.ZERO

	enemigo.cambiar_estado_animacion("idle")


func actualizar(delta):

	tiempo_actual -= delta
	
	print("REPOSO")

	# Si encuentra jugador
	if enemigo.jugador != null:

		transicion.emit("MukiHostigar")
		return

	# Cambio automatico despues de reposo
	if tiempo_actual <= 0:

		transicion.emit("MukiHostigar")


func actualizar_fisica(delta):

	enemigo.velocity = Vector2.ZERO

	enemigo.move_and_slide()


func salir():

	pass
