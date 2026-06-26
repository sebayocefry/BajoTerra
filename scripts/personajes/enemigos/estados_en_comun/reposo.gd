extends Estado

var punto_origen: Vector2
var punto_destino: Vector2
var tiempo_espera: float = 0.0
var velocidad_patrulla: float

func entrar():
	punto_origen = enemigo.global_position
	velocidad_patrulla = enemigo.velocidad * 0.4 # Patrulla lento
	_escoger_nuevo_destino()

func _escoger_nuevo_destino():
	# Intentar hasta 5 veces buscar un punto válido que no cruce paredes
	for i in range(5):
		var offset_random = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		var punto_candidato = punto_origen + offset_random
		if enemigo.es_punto_caminable(punto_candidato):
			punto_destino = punto_candidato
			tiempo_espera = randf_range(1.0, 3.0)
			return
			
	# Si está atrapado, se queda quieto
	punto_destino = punto_origen
	tiempo_espera = randf_range(1.0, 3.0)

func actualizar_fisica(delta: float):
	if enemigo.jugador and enemigo.tiene_linea_de_vision():
		transicion.emit("Perseguir")
		return
			
	if tiempo_espera > 0:
		tiempo_espera -= delta
		enemigo.velocity = enemigo.velocity.lerp(Vector2.ZERO, 10 * delta)
		if enemigo.has_method("actualizar_animacion"):
			enemigo.actualizar_animacion("idle")
		elif animador and animador.has_animation(enemigo.anim_reposo):
			animador.play(enemigo.anim_reposo)
	else:
		var distancia_al_destino = enemigo.global_position.distance_to(punto_destino)
		if distancia_al_destino < 10:
			_escoger_nuevo_destino()
		else:
			var direccion = enemigo.global_position.direction_to(punto_destino)
			enemigo.velocity = direccion * velocidad_patrulla
			if enemigo.has_method("actualizar_animacion"):
				if enemigo.has_method("actualizar_direccion"):
					enemigo.actualizar_direccion(direccion)
				enemigo.actualizar_animacion("run")
			elif animador and animador.has_animation(enemigo.anim_movimiento):
				animador.play(enemigo.anim_movimiento)
				
			if not enemigo.has_method("actualizar_animacion"):
				if direccion.x < 0 and visual:
					visual.flip_h = true
				elif direccion.x > 0 and visual:
					visual.flip_h = false
				
	enemigo.move_and_slide()
