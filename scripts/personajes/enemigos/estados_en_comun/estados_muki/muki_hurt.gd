extends Estado

class_name MukiHurt

@export var tiempo_hurt: float = 0.4
@export var fuerza_retroceso: float = 140.0

var _direccion_golpe: Vector2 = Vector2.ZERO
var _timer: float = 0.0


func entrar():
	_timer = 0.0
	enemigo.cambiar_estado_animacion("hurt")

	# Calcula retroceso desde la posición del jugador
	if enemigo.jugador != null:
		_direccion_golpe = (enemigo.global_position - enemigo.jugador.global_position).normalized()
		enemigo.actualizar_direccion(_direccion_golpe)
	else:
		_direccion_golpe = Vector2.ZERO


func actualizar(delta):
	if enemigo.muerto:
		return

	_timer += delta
	if _timer >= tiempo_hurt:
		if enemigo.vida <= 0:
			enemigo.morir()
		else:
			transicion.emit("MukiHostigar")


func actualizar_fisica(_delta):
	# Aplica el retroceso mientras dure el hurt
	var factor = 1.0 - (_timer / tiempo_hurt)
	enemigo.velocity = _direccion_golpe * fuerza_retroceso * factor
	enemigo.move_and_slide()


func salir():
	enemigo.velocity = Vector2.ZERO
