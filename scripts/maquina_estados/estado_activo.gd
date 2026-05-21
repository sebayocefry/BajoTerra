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
	
	#  Disparar
	if event.is_action_pressed("disparar"):
		player.gestor_armas.apretar_gatillo()
		
	# Usar el objeto que tenemos seleccionado actualmente
	elif event.is_action_pressed("usar_objeto"): 
		player.gestor_inventario.usar_objeto_seleccionado()
		
	#  Cambiar al siguiente objeto de la mochila
	elif event.is_action_pressed("ciclar_objeto"): # Asegúrate de crear "ciclar_objeto" en el Input Map
		player.gestor_inventario.ciclar_objeto()
		
	#  Hablar con NPCs
	elif event.is_action_pressed("interactuar"):
		var npcs_cercanos = player.get_node("DetectorNPC").get_overlapping_areas()
		
		for npc in npcs_cercanos:
			if npc is NPCDialogo:
				npc.iniciar_conversacion()
				transicion.emit("EstadoDialogoJugador")
				return
