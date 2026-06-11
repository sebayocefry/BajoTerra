extends Area2D
class_name Dinamita

@export var velocidad: float = 250.0
@export var tiempo_mecha: float = 2.0
@export var escena_explosion: PackedScene

var direccion: Vector2 = Vector2.ZERO
var dano: int = 0

var _tiempo: float = 0.0

func _ready() -> void:
	rotation = direccion.angle()
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	# Reproducir animación si tiene frames asignados
	var anim: AnimatedSprite2D = $AnimatedSprite2D
	if anim.sprite_frames and anim.sprite_frames.has_animation("default"):
		anim.play("default")

func _physics_process(delta: float) -> void:
	_tiempo += delta
	position += direccion * velocidad * delta
	if _tiempo >= tiempo_mecha:
		_explotar()

func _explotar() -> void:
	if escena_explosion:
		var exp = escena_explosion.instantiate()
		exp.global_position = global_position
		exp.dano = dano
		get_tree().current_scene.add_child(exp)
	queue_free()
