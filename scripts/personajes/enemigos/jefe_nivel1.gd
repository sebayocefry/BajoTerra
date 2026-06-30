extends Entidad
class_name JefeNivel1

@export var escena_bola_fuego: PackedScene
@export var escena_cristal: PackedScene
@export var escena_oro: PackedScene
@export var dano_bola: int = 20
@export var velocidad_bola: float = 200.0
@export var cadencia_ataque: float = 2.5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_ataque: Timer = $TimerAtaque
@onready var punto_disparo: Marker2D = $PuntoDisparo

var _jugador: Player = null
var _fase_enojo: bool = false
# Cada cuántos ataques normales se dispara el circular
const ATAQUES_PARA_CIRCULAR: int = 4
var _contador_ataques: int = 0

func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	_jugador = get_tree().get_first_node_in_group("player")
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("default"):
		sprite.play("default")
	timer_ataque.timeout.connect(_atacar)
	timer_ataque.start()

func _atacar() -> void:
	if not is_instance_valid(_jugador) or not escena_bola_fuego:
		return

	_contador_ataques += 1

	if _contador_ataques >= ATAQUES_PARA_CIRCULAR:
		_disparar_circular()
		_contador_ataques = 0
	else:
		_disparar_hacia_jugador()

func _disparar_hacia_jugador() -> void:
	var origen: Vector2 = sprite.global_position
	var dir: Vector2 = (_jugador.global_position - origen).normalized()
	_crear_bola(origen, dir)

func _disparar_circular() -> void:
	var origen: Vector2 = sprite.global_position
	var cantidad: int = 8
	for i in range(cantidad):
		var angulo: float = (TAU / cantidad) * i
		var dir: Vector2 = Vector2(cos(angulo), sin(angulo))
		_crear_bola(origen, dir)

func _crear_bola(origen: Vector2, dir: Vector2) -> void:
	var bola: BolaDeFuego = escena_bola_fuego.instantiate()
	get_tree().current_scene.add_child(bola)
	bola.global_position = origen
	bola.dano = dano_bola
	bola.inicializar(dir, velocidad_bola)

func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO) -> void:
	super.recibir_dano(cantidad, vector_empuje)
	if not is_instance_valid(sprite):
		return

	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color(2.0, 0.3, 0.3), 0.07)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.18)

	# Activar fase de enojo al llegar al 50% de vida
	if not _fase_enojo and vida <= vida_maxima / 2:
		_activar_fase_enojo()

func _activar_fase_enojo() -> void:
	_fase_enojo = true
	# Duplicar velocidad de ataque
	timer_ataque.wait_time = cadencia_ataque / 2.0
	timer_ataque.start()
	# Bolas más rápidas
	velocidad_bola *= 1.5
	# Tinte rojizo permanente para indicar fase de enojo
	sprite.modulate = Color(1.5, 0.4, 0.4)

func morir() -> void:
	timer_ataque.stop()
	if escena_cristal:
		var cristal := escena_cristal.instantiate()
		cristal.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", cristal)
	if escena_oro:
		var oro := escena_oro.instantiate()
		oro.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", oro)
	print("¡Jefe del nivel 1 derrotado!")
	super.morir()
