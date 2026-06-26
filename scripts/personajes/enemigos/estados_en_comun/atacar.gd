extends Estado

@export var cooldown_ataque: float = 1.0
var temporizador: float = 0.0

func entrar():
	enemigo.velocity = Vector2.ZERO
	
	# Igualamos el temporizador al cooldown para que el 
	# primer golpe lo dé instantáneamente nada más entrar al estado.
	temporizador = cooldown_ataque 

func actualizar_fisica(delta: float):
	if not enemigo.jugador:
		return
		
	# 1. Mantener la mirada hacia el jugador
	var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)
	if enemigo.has_method("actualizar_animacion"):
		if enemigo.has_method("actualizar_direccion"):
			enemigo.actualizar_direccion(direccion)
	else:
		enemigo.sprite.flip_h = direccion.x < 0
		
	# Si el minero se alejó más allá de la zona de ataque y de la distancia segura, cortamos el ataque
	var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)
	if not enemigo.jugador_en_rango and distancia > enemigo.distancia_ataque:
		transicion.emit("Perseguir")
		return
		
	# lpgica del cooldown por delta 
	temporizador += delta
	if temporizador >= cooldown_ataque:
		ejecutar_golpe()
		temporizador = 0.0 # Reiniciamos el reloj para el proximo golpe

func ejecutar_golpe():
	# Solo reproducimos la animación desde cero si no se esta reproduciendo ya
	if enemigo.has_method("actualizar_animacion"):
		enemigo.actualizar_animacion("attack")
	elif animador.current_animation != enemigo.anim_ataque:
		animador.play(enemigo.anim_ataque)
		
	# Telegraphing: Esperar 0.4 segundos antes de asestar el golpe para que el jugador pueda esquivar
	await get_tree().create_timer(0.4).timeout
	
	# Comprobar si el enemigo y el jugador aún existen
	if not is_instance_valid(enemigo) or not is_instance_valid(enemigo.jugador):
		return
		
	# Si el jugador esquivó y salió del rango durante el tiempo de carga, el ataque falla!
	var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)
	if enemigo.jugador_en_rango or distancia <= enemigo.distancia_ataque:
		print(enemigo.name, " asesta un golpe de: ", enemigo.dano_contacto)
		enemigo.jugador.recibir_dano(enemigo.dano_contacto)
