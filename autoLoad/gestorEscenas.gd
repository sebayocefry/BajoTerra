extends Node

signal nivel_cargado(nombre_nivel: String)

func cambiar_nivel(ruta_nuevo_nivel: String):
    #  Antes de destruir la escena, guardamos al jugador
    var player = get_tree().get_first_node_in_group("Player")
    if player:
        DatosJugador.guardar_estado_jugador(player)
    else:
        push_warning("Arquitectura: No se encontró un nodo en el grupo 'Player' para guardar.")
    call_deferred("_transicion_segura", ruta_nuevo_nivel)

func _transicion_segura(ruta: String):
    var resultado = get_tree().change_scene_to_file(ruta)
    
    if resultado == OK:
        print("Transición exitosa a: ", ruta)
        
        # eperamos un frame para que Godot termine de instanciar el nuevo mapa
        await get_tree().process_frame 
        
        #  Buscamos al nuevo jugador que acaba de nacer en esta escena y le inyectamos los datos
        var nuevo_player = get_tree().get_first_node_in_group("Player")
        if nuevo_player:
            DatosJugador.cargar_estado_jugador(nuevo_player)
            
        nivel_cargado.emit(ruta)
    else:
        push_error("Error Crítico: No se pudo cargar la escena en " + ruta)