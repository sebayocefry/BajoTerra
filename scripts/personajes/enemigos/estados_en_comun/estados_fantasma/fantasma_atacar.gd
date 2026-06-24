extends Estado

@export var cooldown_ataque : float = 2.0

var temporizador := 0.0


func entrar():
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()
	temporizador = cooldown_ataque


func actualizar_fisica(delta):
	if not enemigo.jugador:
		return

	# Dirección hacia jugador
	var direccion = enemigo.global_position.direction_to(
		enemigo.jugador.global_position
	)

	enemigo.actualizar_direccion(direccion)
	enemigo.actualizar_animacion("direccion")

	# Si el jugador sale del rango
	if not enemigo.jugador_en_rango:
		transicion.emit("Perseguir")
		return

	# Cooldown
	temporizador += delta

	if temporizador >= cooldown_ataque:
		enemigo.disparar()
		temporizador = 0.0
