extends Estado

class_name MukiAtacar

@export var duracion_ataque: float = 0.8

var _timer: float = 0.0
var _golpe_aplicado: bool = false


func entrar():
	_timer = 0.0
	_golpe_aplicado = false
	enemigo.velocity = Vector2.ZERO
	enemigo.cambiar_estado_animacion("attack")

	if enemigo.jugador == null:
		return

	var direccion = (enemigo.jugador.global_position - enemigo.global_position).normalized()
	enemigo.actualizar_direccion(direccion)

	# Aplica el daño inmediatamente al entrar
	enemigo.jugador.recibir_dano(
		enemigo.dano_muki,
		direccion * 250
	)
	_golpe_aplicado = true


func actualizar(delta):
	if enemigo.muerto:
		return

	_timer += delta
	if _timer >= duracion_ataque:
		# Después de atacar, el muki huye — esto da el comportamiento errático de grupo
		transicion.emit("MukiHuir")


func actualizar_fisica(_delta):
	enemigo.velocity = Vector2.ZERO


func salir():
	_golpe_aplicado = false
