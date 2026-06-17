extends Area2D

var dano: int = 0
var fuerza: float = 300.0

func _ready() -> void:
	# Esperar un frame de física para detectar solapamientos
	await get_tree().physics_frame
	for cuerpo in get_overlapping_bodies():
		if cuerpo.has_method("recibir_dano"):
			var dir: Vector2 = global_position.direction_to(cuerpo.global_position)
			cuerpo.recibir_dano(dano, dir * fuerza)
	queue_free()
