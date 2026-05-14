extends Enemigo

class_name EnemigoGolem


@onready var sprite_animado = $AnimatedSprite2D

# Última dirección hacia donde mira el enemigo
var last_direction = "down"

# Evita ejecutar morir() múltiples veces
var muerto = false


func _ready():
	super._ready()
	
func _on_zona_ataque_body_entered(body):
	
	print("JUGADOR EN RANGO")
	

	super._on_zona_ataque_body_entered(body)


func _on_zona_ataque_body_exited(body):
	
	print("JUGADOR SALIÓ")
	super._on_zona_ataque_body_exited(body)

# direccION

func actualizar_direccion(direccion: Vector2):

	if abs(direccion.x) > abs(direccion.y):
		last_direction = "right" if direccion.x > 0 else "left"
	else:
		last_direction = "down" if direccion.y > 0 else "up"

# ANIMACIONES

func actualizar_animacion(estado: String):

	var nombre_animacion = estado + "_" + last_direction

	sprite_animado.play(nombre_animacion)

# DAÑO

func recibir_dano(
	cantidad: int,
	vector_empuje: Vector2 = Vector2.ZERO
):

	# Evita recibir daño si ya murió
	if muerto:
		return

	var vida_anterior = vida

	# Ejecuta lógica base de Entidad/Enemigo
	super.recibir_dano(cantidad, vector_empuje)

	# Si realmente recibió daño y sigue vivo
	if vida < vida_anterior and vida > 0:

		actualizar_animacion("hurt")

# ESTA ES LA mUERTE

func morir():

	# Evita ejecutar muerte múltiples veces
	if muerto:
		return

	muerto = true

	# Detiene movimiento
	velocity = Vector2.ZERO

	# Apaga IA
	maquina_estados.set_physics_process(false)
	maquina_estados.set_process(false)

	# Reproduce animación death
	actualizar_animacion("death")

	# Espera fin de animación
	await sprite_animado.animation_finished
	
	queue_free()
