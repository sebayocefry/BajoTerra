extends EstadoJefe

@export var cooldown_ataque : float = 1.4

var temporizador : float = 0.0

func entrar():
	enemigo.velocity = Vector2.ZERO
	enemigo.move_and_slide()

	temporizador = cooldown_ataque

	if animacion.has_animation(enemigo.anim_demonio_ataque):
		animacion.play(enemigo.anim_demonio_ataque)

	print("Jefe atacando en fase demonio")

func actualizar_fisica(delta):
	if enemigo.jugador == null:
		transicion.emit("Reposo")
		return

	var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)

	if direccion.x < 0:
		sprite_demonio.flip_h = true
	elif direccion.x > 0:
		sprite_demonio.flip_h = false

	if not enemigo.jugador_en_rango_demonio:
		transicion.emit("Perseguir")
		return

	temporizador += delta

	if temporizador >= cooldown_ataque:
		ejecutar_golpe_demonio()
		temporizador = 0.0

func ejecutar_golpe_demonio():
	if animacion.has_animation(enemigo.anim_demonio_ataque):
		animacion.play(enemigo.anim_demonio_ataque)

	print("Jefe demonio golpea: ", enemigo.dano_demonio)

	if enemigo.jugador and enemigo.jugador.has_method("recibir_dano"):
		enemigo.jugador.recibir_dano(enemigo.dano_demonio)
