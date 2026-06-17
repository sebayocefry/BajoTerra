extends Area2D
class_name Explosion

var dano: int = 0
var fuerza: float = 400.0

func _ready() -> void:
	# Reproducir animación si tiene frames asignados
	var anim: AnimatedSprite2D = $AnimatedSprite2D
	if anim.sprite_frames and anim.sprite_frames.has_animation("default"):
		anim.play("default")
	# Esperar un frame para detectar cuerpos en el área
	await get_tree().physics_frame
	for cuerpo in get_overlapping_bodies():
		if cuerpo.has_method("recibir_dano"):
			var dir: Vector2 = global_position.direction_to(cuerpo.global_position)
			cuerpo.recibir_dano(dano, dir * fuerza)
	# Liberar tras 0.5s para que la animación de explosión se vea
	await get_tree().create_timer(0.5).timeout
	queue_free()
