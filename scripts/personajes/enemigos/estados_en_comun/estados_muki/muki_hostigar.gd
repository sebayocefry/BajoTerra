extends Estado

class_name MukiHostigar

@export var distancia_ataque: float = 120.0
@export var velocidad_hostigamiento: float = 120.0


func entrar():
	enemigo.cambiar_estado_animacion("run")


func actualizar(_delta):
	if enemigo.jugador == null or not enemigo.tiene_linea_de_vision():
		transicion.emit("MukiReposo")
		return
		return

	var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)

	# Si el jugador se aleja demasiado, vuelve a reposar
	if distancia > enemigo.distancia_vision * 1.5:
		transicion.emit("MukiReposo")
		return

	if distancia <= distancia_ataque:
		transicion.emit("MukiAtacar")


func actualizar_fisica(_delta):
	if enemigo.jugador == null:
		return

	var objetivo = enemigo.obtener_posicion_hostigamiento()
	var direccion = (objetivo - enemigo.global_position).normalized()
	var separacion = enemigo.calcular_separacion()
	var random_mov = enemigo.obtener_movimiento_random()

	var direccion_final = (direccion + separacion + random_mov).normalized()

	enemigo.velocity = direccion_final * velocidad_hostigamiento

	if direccion_final.length() > 0.1:
		enemigo.actualizar_direccion(direccion_final)

	# Usa "idle" cuando casi no se mueve, evita animaciones inexistentes como "walk"
	if enemigo.velocity.length() > 10:
		enemigo.cambiar_estado_animacion("run")
	else:
		enemigo.cambiar_estado_animacion("idle")

	enemigo.move_and_slide()


func salir():
	enemigo.velocity = Vector2.ZERO
