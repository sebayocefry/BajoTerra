extends Arma
class_name ArmaLanzable

@export var velocidad_lanzamiento: float = 250.0

func ejecutar_disparo(jugador: Player, direccion: Vector2, punto_disparo: Vector2) -> void:
	if not escena_bala:
		push_error("ArmaLanzable: no tiene escena_bala asignada.")
		return
	var objeto = escena_bala.instantiate()
	jugador.get_tree().current_scene.add_child(objeto)
	objeto.global_position = punto_disparo
	objeto.direccion = direccion
	objeto.dano = dano
	if "velocidad" in objeto:
		objeto.velocidad = velocidad_lanzamiento
