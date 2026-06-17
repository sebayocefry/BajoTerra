extends Estado
class_name EstadoActivoJugador

func actualizar_fisica(_delta: float):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var player = actor as Player
	if not player: return

	player.movement.move(player, input_direction)
	player.handle_animations(input_direction)

func manejar_input(event: InputEvent):
	var player = actor as Player
	if not player: return

	# El disparo con flechas lo maneja gestor_armas._process() automáticamente.

	if event.is_action_pressed("usar_objeto"):
		if player.gestor_inventario:
			player.gestor_inventario.usar_objeto_seleccionado()

	elif event.is_action_pressed("ciclar_objeto"):
		if player.gestor_inventario:
			player.gestor_inventario.ciclar_objeto()

	elif event.is_action_pressed("arma_siguiente"):
		pass  # gestor_armas lo maneja con _unhandled_input

	elif event.is_action_pressed("interactuar"):
		var detector = player.get_node_or_null("DetectorNPC")
		if detector == null:
			return
		var npcs_cercanos = detector.get_overlapping_areas()
		for npc in npcs_cercanos:
			if npc is NPCDialogo:
				npc.iniciar_conversacion()
				transicion.emit("EstadoDialogoJugador")
				return
