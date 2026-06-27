extends EstadoJefe

@export var cooldown_ataque : float = 1.0

var temporizador : float = 0.0

func entrar():
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	temporizador = cooldown_ataque

	if animacion.has_animation(enemigo.anim_ataque):
		animacion.play(enemigo.anim_ataque)

	print("Jefe atacando en fase chica")

func actualizar_fisica(delta):
	if enemigo.jugador == null:
		transicion.emit("Reposo")
		return

	var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)

	if direccion.x < 0:
		sprite_chico.flip_h = false
	elif direccion.x > 0:
		sprite_chico.flip_h = true

	if not enemigo.jugador_en_rango:
		transicion.emit("Perseguir")
		return

	temporizador += delta

	if temporizador >= cooldown_ataque:
		ejecutar_golpe()
		temporizador = 0.0

func ejecutar_golpe():
	if animacion.has_animation(enemigo.anim_ataque):
		animacion.play(enemigo.anim_ataque)

	print("Jefe golpea en fase chica: ", enemigo.dano_contacto)

	if enemigo.jugador and enemigo.jugador.has_method("recibir_dano"):
		enemigo.jugador.recibir_dano(enemigo.dano_contacto)
