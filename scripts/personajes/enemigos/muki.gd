extends Enemigo

class_name Muki


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# DIRECCION Y ANIMACION

var estado_animacion: String = "idle"
var direccion_actual: String = "down"


# SWARM AI

@export var radio_hostigamiento: float = 120.0
@export var fuerza_separacion: float = 0.8
@export var distancia_separacion: float = 60.0
@export var fuerza_random: float = 0.15
@export var dano_muki: int = 5

# READY

func _ready():

	super._ready()

	add_to_group("mukis")

# DETECCION JUGADOR

func _on_zona_ataque_body_entered(body):

	print("JUGADOR EN RANGO")

	super._on_zona_ataque_body_entered(body)

func _on_zona_ataque_body_exited(body):

	print("JUGADOR SALIÓ")

	super._on_zona_ataque_body_exited(body)

# ANIMACIONES

func reproducir_animacion():

	var nombre_animacion = estado_animacion + "_" + direccion_actual

	if animated_sprite.sprite_frames.has_animation(nombre_animacion):

		if animated_sprite.animation != nombre_animacion:
			animated_sprite.play(nombre_animacion)

# DIRECCIONES

func actualizar_direccion(vector_direccion: Vector2):

	if vector_direccion.length() < 0.1:
		return


	if abs(vector_direccion.x) > abs(vector_direccion.y):

		if vector_direccion.x > 0:
			direccion_actual = "right"
		else:
			direccion_actual = "left"

	else:

		if vector_direccion.y > 0:
			direccion_actual = "down"
		else:
			direccion_actual = "up"


	reproducir_animacion()

# cambiaR ESTADO VISUAL

func cambiar_estado_animacion(nuevo_estado: String):

	if estado_animacion != nuevo_estado:

		estado_animacion = nuevo_estado
		reproducir_animacion()

# SWARM - SEPARACION

func calcular_separacion() -> Vector2:

	var fuerza = Vector2.ZERO

	for muki in get_tree().get_nodes_in_group("mukis"):

		if muki == self:
			continue

		var distancia = global_position.distance_to(muki.global_position)

		if distancia < distancia_separacion:

			var direccion = (global_position - muki.global_position).normalized()

			fuerza += direccion

	if fuerza.length() > 0:
		fuerza = fuerza.normalized() * fuerza_separacion

	return fuerza

# SWARM - HOSTIGAMIENTO

func obtener_posicion_hostigamiento() -> Vector2:

	if jugador == null:
		return global_position

	# Cada Muki obtiene un angulo distinto
	var angulo = float(get_instance_id() % 360)

	var offset = Vector2.RIGHT.rotated(
			deg_to_rad(angulo)
		) * radio_hostigamiento

	return jugador.global_position + offset

# MOVIMIENTO ERRATICO

func obtener_movimiento_random() -> Vector2:

	return Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized() * fuerza_random
	
	
func recibir_dano(
	cantidad: int,
	vector_empuje: Vector2 = Vector2.ZERO
):

	super.recibir_dano(
		cantidad,
		vector_empuje
	)

	# SI SIGUE VIVO -> HURT

	if vida > 0:

		cambiar_estado_animacion("hurt")
# MUERTE

func morir():

	cambiar_estado_animacion("death")

	set_physics_process(false)

	await animated_sprite.animation_finished

	queue_free()
