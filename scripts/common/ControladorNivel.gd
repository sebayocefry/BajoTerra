extends Node2D

@onready var puerta_salida = $PuntoSalida 
var nombre_escena : String
var enemigos_vivos : int = 0

func _ready():
    # Usamos la ruta del archivo como ID único de esta habitación
    nombre_escena = get_tree().current_scene.scene_file_path
    var lista_enemigos = get_tree().get_nodes_in_group("Enemigos")
    
    #  Consultar a la base de datos si ya pasamos por aqu
    if DatosJugador.habitaciones_limpias.get(nombre_escena, false):
        print("Habitación ya limpiada anteriormente. Borrando enemigos...")
        for enemigo in lista_enemigos:
            enemigo.queue_free()
        puerta_salida.desbloquear()
    else:
        #  Es la primera vez que entramos
        enemigos_vivos = lista_enemigos.size()
        if enemigos_vivos > 0:
            puerta_salida.bloquear() 
            for enemigo in lista_enemigos:
                enemigo.entidad_morir.connect(_on_enemigo_muerto)
        else:
            puerta_salida.desbloquear()

func _on_enemigo_muerto():
    enemigos_vivos -= 1
    if enemigos_vivos <= 0:
        print("¡Habitación despejada!")
    #aplicamos uun singleton para que no se nos duplique
        DatosJugador.habitaciones_limpias[nombre_escena] = true
        puerta_salida.desbloquear()