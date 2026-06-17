
extends CanvasLayer
@export_file("*.tscn") var ruta_menu_principal: String
func _ready():
    # Se esconde por defecto al arrancar el juego
    hide()
    # Escucha el evento que creamos antes
    Eventos.jugador_muerto.connect(_mostrar_pantalla)

func _mostrar_pantalla():
    show()
    # pausa el juego cuando mueres asi los enemigos no se mueven 
    get_tree().paused = true 

func _on_boton_reintentar_pressed():
    get_tree().paused = false 
    
    #  Intentamos cargar los datos del disco duro
    if SistemaGuardado.cargar_partida():
        #  Si hay partida, volvemos a la escena donde guardamos
        var datos = DatosJugador.obtener_datos_diccionario()
        var escena_guardada = datos.get("ultima_escena")
        GestorEscenas.cambiar_nivel(escena_guardada)
    else:
        if ruta_menu_principal != "":
            GestorEscenas.cambiar_nivel(ruta_menu_principal)
        else:
            push_error("Arquitectura: No has asignado la ruta del menu principal en el Inspector.")
    
    hide() 