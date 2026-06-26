extends "res://scripts/personajes/enemigos/estados_en_comun/atacar.gd"

func ejecutar_golpe():
	if enemigo.has_method("actualizar_animacion"):
		enemigo.actualizar_animacion("attack")

	# Telegraphing: pequeña espera antes de soltar el disparo
	await get_tree().create_timer(0.4).timeout

	if not is_instance_valid(enemigo) or not is_instance_valid(enemigo.jugador):
		return

	var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)
	if enemigo.jugador_en_rango or distancia <= enemigo.distancia_ataque:
		enemigo.disparar()
