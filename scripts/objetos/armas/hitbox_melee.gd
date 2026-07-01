extends Area2D

var dano: int = 0
var fuerza: float = 300.0
var cuerpos_golpeados: Array = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# Destruir el hitbox después de un corto tiempo (animación del golpe)
	await get_tree().create_timer(0.15).timeout
	queue_free()

func _on_body_entered(cuerpo: Node2D) -> void:
	if cuerpo is Player or cuerpo in cuerpos_golpeados:
		return
		
	if cuerpo.has_method("recibir_dano"):
		cuerpos_golpeados.append(cuerpo)
		var dir: Vector2 = global_position.direction_to(cuerpo.global_position)
		cuerpo.recibir_dano(dano, dir * fuerza)
