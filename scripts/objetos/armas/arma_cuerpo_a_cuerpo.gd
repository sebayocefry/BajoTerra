extends Arma
class_name ArmaCuerpoACuerpo

@export var escena_hitbox: PackedScene
@export var escena_efecto: PackedScene
@export var distancia_golpe: float = 70.0
@export var fuerza_golpe: float = 300.0

func ejecutar_disparo(jugador: Player, direccion: Vector2, punto_disparo: Vector2) -> void:
	if not escena_hitbox:
		push_error("ArmaCuerpoACuerpo: no tiene escena_hitbox asignada.")
		return
	var hitbox = escena_hitbox.instantiate()
	
	# Añadimos al current_scene de forma segura
	jugador.get_tree().current_scene.add_child(hitbox)
		
	# Posicionar el hitbox frente al jugador en la dirección de ataque
	hitbox.global_position = punto_disparo + direccion * distancia_golpe
	hitbox.dano = dano
	hitbox.fuerza = fuerza_golpe
	hitbox.escena_efecto = escena_efecto

	if escena_efecto:
		var efecto = escena_efecto.instantiate()
		efecto.global_position = hitbox.global_position
		jugador.get_tree().current_scene.add_child(efecto)
