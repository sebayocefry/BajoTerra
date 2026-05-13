extends Estado
class_name EstadoActivoJugador

func actualizar_fisica(_delta: float):
    var input_direction = Input.get_vector("left", "right", "up", "down")
    
    # Como 'actor' es una Entidad, Godot no sabe de base que tiene el nodo 'movement'.
    # Hacemos un casteo seguro para acceder a las variables específicas del Player.
    var player = actor as Player
    if not player: return
    
    player.movement.move(player, input_direction)
    player.handle_animations(input_direction)

func manejar_input(event: InputEvent):
    var player = actor as Player
    if not player: return
    
    if event.is_action_pressed("disparar"):
        player.gestor_armas.apretar_gatillo()
        
    elif event.is_action_pressed("ui_accept"):
        player.usar_objeto_inventario(0)
        
    elif event.is_action_pressed("interactuar"):

        var npcs_cercanos = player.get_node("DetectorNPC").get_overlapping_areas()
        
        for npc in npcs_cercanos:
            if npc is NPCDialogo:
                #  Obligamos al NPC a que inicie el plugin de tus compañeros
                npc.iniciar_conversacion()
                # 2. Nos bloqueamos a nosotros mismos inmediatamente
                transicion.emit("EstadoDialogoJugador")
                return # Cortamos el loop para no hablar con 2 a la vez