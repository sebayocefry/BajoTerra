extends CanvasLayer

@onready var grid_container = %GridContainer
@onready var boton_salir = %BotonSalir


var comerciante_actual: Comerciante = null
var jugador_actual: Player = null

func _ready():
    hide()
    # para que la UI funcione con el juego pausado
    process_mode = Node.PROCESS_MODE_ALWAYS 
    
    Eventos.solicitar_apertura_tienda.connect(_on_solicitar_apertura_tienda)
    
    
    boton_salir.pressed.connect(_cerrar_tienda)

func _on_solicitar_apertura_tienda(inventario: Array, comerciante_referencia: Comerciante):
    #  Congelamos el mundo y mostramos el fondo de la tienda
    get_tree().paused = true
    show()
    
    comerciante_actual = comerciante_referencia
    jugador_actual = comerciante_referencia.jugador_en_rango
    
    # Limpieza de GUI (Borramos botones de compras anteriores)
    for hijo in grid_container.get_children():
        hijo.queue_free()
        
    # Vamos generanod los botones de fprma dinamica, onda en el for recorremos la lista 
    # y este va ahi haciendo los botones
    for objeto in inventario:
        if objeto != null:
            crear_boton_objeto(objeto)




func crear_boton_objeto(objeto: Objeto):
    var nuevo_boton = Button.new()
    
    
    nuevo_boton.text = objeto.nombre + " - " + str(objeto.precio_oro) + " Oro"
    if objeto.icono:
        nuevo_boton.icon = objeto.icono
        #  icono si es muy grande
        nuevo_boton.expand_icon = true 
    
    nuevo_boton.custom_minimum_size = Vector2(200, 60) 
    nuevo_boton.pressed.connect(_on_boton_comprar_presionado.bind(objeto))
    grid_container.add_child(nuevo_boton)

func _on_boton_comprar_presionado(objeto_seleccionado: Objeto):
    if comerciante_actual and jugador_actual:
        var exito = comerciante_actual.intentar_comprar_objeto(jugador_actual, objeto_seleccionado)
        if exito:
            #aqui podemos poner un sonido a futuro o un evento 
            print("UI: Objeto comprado exitosamente.")
        else:
            #aqui algo para cuando no haya plata
            print("UI: Compra rechazada.")

func _cerrar_tienda():
    hide()
    get_tree().paused = false
    comerciante_actual = null
    jugador_actual = null