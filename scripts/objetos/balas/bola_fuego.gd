extends Area2D
class_name BolaDeFuego

@export var dano: int = 20
@export var velocidad: float = 200.0

var _direccion: Vector2 = Vector2.RIGHT

func inicializar(dir: Vector2, vel: float = 200.0) -> void:
	_direccion = dir.normalized()
	velocidad = vel
	rotation = _direccion.angle()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	# Auto-destruir después de 8 segundos por si no golpea nada
	get_tree().create_timer(8.0).timeout.connect(queue_free)
	# Reproducir animación si tiene frames asignados
	var anim: AnimatedSprite2D = $AnimatedSprite2D
	if anim.sprite_frames and anim.sprite_frames.has_animation("default"):
		anim.play("default")

func _physics_process(delta: float) -> void:
	global_position += _direccion * velocidad * delta

func _on_body_entered(cuerpo: Node2D) -> void:
	if cuerpo is Player:
		cuerpo.recibir_dano(dano, _direccion * 150.0)
	# Destruir la bola al tocar cualquier cuerpo (muro o jugador)
	queue_free()
