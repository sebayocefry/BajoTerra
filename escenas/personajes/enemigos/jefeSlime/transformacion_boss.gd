extends Estado

func entrar():
	enemigo.velocity = Vector2.ZERO # Se queda quieto para transformarse
	animacion.play("transformacion")
	
	# Esperamos a que la animación que configuraste termine
	await animacion.animation_finished
	
	# Cambiamos las estadísticas al modo Demonio
	enemigo.vida_maxima = 500
	enemigo.vida = 500
	enemigo.velocidad = 150 # Más rápido que el slime
	
	# Pasamos a la pelea final
	transicion.emit("FaseDemonio")
