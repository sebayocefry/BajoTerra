extends Estado

func entrar():
	# Asegúrate de que este nombre sea IGUAL al del AnimationPlayer
	animacion.play("chico_idle") 

func actualizar_fisica(delta):
	# Si no hay gravedad o movimiento aquí, el KinematicBody no hará nada
	if not enemigo.is_on_floor():
		enemigo.velocity.y += 980 * delta # Gravedad simple
	
	enemigo.move_and_slide()
	
	# Si detecta al jugador, cambia a transformación
	if enemigo.jugador_en_rango:
		transicion.emit("Transformacion")
