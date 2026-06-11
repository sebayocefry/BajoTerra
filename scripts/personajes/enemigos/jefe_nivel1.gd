extends Entidad
class_name JefeNivel1

@export var escena_bola_fuego: PackedScene
@export var escena_cristal: PackedScene
@export var dano_bola: int = 20
@export var velocidad_bola: float = 200.0
@export var cadencia_ataque: float = 2.5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_ataque: Timer = $TimerAtaque
@onready var punto_disparo: Marker2D = $PuntoDisparo

var _jugador: Player = null

func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	_jugador = get_tree().get_first_node_in_group("player")
	# Reproducir animación si existe
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("default"):
		sprite.play("default")
	timer_ataque.timeout.connect(_atacar)
	timer_ataque.start()

func _atacar() -> void:
	if not is_instance_valid(_jugador) or not escena_bola_fuego:
		return

	# Usar el centro visual del sprite como origen (el nodo raíz está desplazado)
	var origen: Vector2 = sprite.global_position

	# Disparar directamente hacia el jugador en cualquier ángulo
	var dir: Vector2 = (_jugador.global_position - origen).normalized()

	# Instanciar y lanzar la bola de fuego desde el centro visual del boss
	var bola: BolaDeFuego = escena_bola_fuego.instantiate()
	get_tree().current_scene.add_child(bola)
	bola.global_position = origen
	bola.dano = dano_bola
	bola.inicializar(dir, velocidad_bola)

func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO) -> void:
	super.recibir_dano(cantidad, vector_empuje)
	if not is_instance_valid(sprite):
		return
	# Destello rojo al recibir daño
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color(2.0, 0.3, 0.3), 0.07)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.18)

func morir() -> void:
	timer_ataque.stop()
	# Soltar cristal de maná como recompensa
	if escena_cristal:
		var cristal := escena_cristal.instantiate()
		cristal.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", cristal)
	print("¡Jefe del nivel 1 derrotado!")
	super.morir()
