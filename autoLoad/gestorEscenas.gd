extends Node

signal nivel_cargado(nombre_nivel: String)

## Habitación a la que volver al salir del comerciante.
## Lo escribe PuertaHaciaComerciate antes de cargar la habitación del comerciante;
## lo lee PuertaSalidaComerciate al salir.
var habitacion_post_comerciante: String = ""

func _get_true_player() -> Node:
    for nodo in get_tree().get_nodes_in_group("player"):
        if "oro" in nodo and "mana" in nodo:
            return nodo
    return null

func cambiar_nivel(ruta_nuevo_nivel: String):
    # Antes de destruir la escena, guardamos al jugador
    var player = _get_true_player()
    if player and player.vida > 0:
        DatosJugador.guardar_estado_jugador(player)
    elif not player:
        push_warning("Arquitectura: No se encontró un nodo en el grupo 'player' para guardar.")
    call_deferred("_transicion_segura", ruta_nuevo_nivel)

func _transicion_segura(ruta: String):
    var resultado = get_tree().change_scene_to_file(ruta)
    
    if resultado == OK:
        print("Transición exitosa a: ", ruta)
        
        # eperamos un frame para que Godot termine de instanciar el nuevo mapa
        await get_tree().process_frame 
        
        #  Buscamos al nuevo jugador que acaba de nacer en esta escena y le inyectamos los datos
        var nuevo_player = _get_true_player()
        if nuevo_player:
            DatosJugador.cargar_estado_jugador(nuevo_player)
            
        nivel_cargado.emit(ruta)
    else:
        push_error("Error Crítico: No se pudo cargar la escena en " + ruta)