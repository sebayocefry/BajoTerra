extends Estado

var zona_ataque: Area2D

func entrar():
	if enemigo.has_method("actualizar_animacion"):
		enemigo.actualizar_animacion("run")
	elif animador.current_animation != enemigo.anim_movimiento:
		animador.play(enemigo.anim_movimiento)
		
	if not zona_ataque:
		zona_ataque = enemigo.get_node("Zona_ataque")
		
	#  Por si el jugador YA estaba dentro de la zona al momento de empezar a perseguir
	var cuerpos_cerca = zona_ataque.get_overlapping_bodies()
	if enemigo.jugador in cuerpos_cerca:
		transicion.emit("Atacar")
		return # Cortamos la función aquí
		
	#  Si no esta adentro, conectamos la señal para esperar a que entre
	zona_ataque.body_entered.connect(_al_jugador_entrar)

func salir():

	if zona_ataque.body_entered.is_connected(_al_jugador_entrar):
		zona_ataque.body_entered.disconnect(_al_jugador_entrar)

func _al_jugador_entrar(cuerpo: Node2D):
	# Esta función se dispara SOLA cuando algo toca el Area2D
	if cuerpo == enemigo.jugador:
		transicion.emit("Atacar")

func actualizar_fisica(_delta: float):
	if not enemigo.jugador:
		return
		
	# Si pierde línea de visión (se esconde detrás de un muro) o se aleja demasiado
	if not enemigo.tiene_linea_de_vision():
		transicion.emit("Reposo")
	elif enemigo.jugador_en_rango or enemigo.global_position.distance_to(enemigo.jugador.global_position) <= enemigo.distancia_ataque:
		# Si está en el área o lo suficientemente cerca (respaldo por si choca físicamente antes de entrar al área)
		enemigo.jugador_en_rango = true
		transicion.emit("Atacar")
	else:
		
		var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)
		enemigo.velocity = direccion * enemigo.velocidad
		
		if enemigo.has_method("actualizar_animacion"):
			if enemigo.has_method("actualizar_direccion"):
				enemigo.actualizar_direccion(direccion)
			enemigo.actualizar_animacion("run")
		else:
			# Truco del espejo
			if direccion.x < 0:
				visual.flip_h = true
			elif direccion.x > 0:
				visual.flip_h = false
		
		enemigo.move_and_slide()
