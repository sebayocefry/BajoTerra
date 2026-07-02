extends Area2D

var dano: int = 0
var fuerza: float = 300.0
var cuerpos_golpeados: Array = []
var escena_efecto: PackedScene = null

func _ready() -> void:
	# Aseguramos que la máscara de colisión escanee la capa 1 y 3 (igual que las balas)
	# Esto soluciona que ignore enemigos como el Golem que están en la capa 1
	collision_mask = 5
	
	body_entered.connect(_on_body_entered)
	
	# Chequeo infalible
	await get_tree().physics_frame
	for cuerpo in get_overlapping_bodies():
		_on_body_entered(cuerpo)
		
	# Destruir el hitbox después de un corto tiempo
	await get_tree().create_timer(0.15).timeout
	queue_free()

func _on_body_entered(cuerpo: Node2D) -> void:
	if cuerpo is Player or cuerpo in cuerpos_golpeados:
		return
		
	if cuerpo.has_method("recibir_dano"):
		cuerpos_golpeados.append(cuerpo)
		var dir: Vector2 = global_position.direction_to(cuerpo.global_position)
		cuerpo.recibir_dano(dano, dir * fuerza)
		if escena_efecto:
			var efecto = escena_efecto.instantiate()
			efecto.global_position = cuerpo.global_position
			get_tree().current_scene.add_child(efecto)
