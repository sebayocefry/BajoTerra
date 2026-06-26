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
	
	if enemigo.jugador and enemigo.tiene_linea_de_vision():
		transicion.emit("MukiHostigar")
		return

	# Si pasó el tiempo de reposo y no hay jugador cerca, sigue esperando
	if tiempo_actual <= 0:
		tiempo_actual = tiempo_reposo


func actualizar_fisica(_delta):
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()


func salir():
	pass
