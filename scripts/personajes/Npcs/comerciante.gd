extends StaticBody2D
class_name Comerciante 

@export var inventario_tienda: Array[Objeto] = []

var jugador_en_rango: Player = null

func _ready():
    $ZonaInteraccion.body_entered.connect(_on_zona_interaccion_body_entered)
    $ZonaInteraccion.body_exited.connect(_on_zona_interaccion_body_exited)


func _unhandled_input(event):
    if jugador_en_rango and event.is_action_pressed("interactuar"):
        abrir_tienda()


func _on_zona_interaccion_body_entered(body: Node2D):
    # verificamos que quien haya entrado sea el jugador y no un enemigo o algo 
    if body is Player:
        jugador_en_rango = body
        print("Presiona 'E' (o tu tecla de interaccion) para comerciar")
        #aqui laura debes poner un evento y un icono para interactuar visualmente 

func _on_zona_interaccion_body_exited(body: Node2D):
    if body == jugador_en_rango:
        jugador_en_rango = null
        cerrar_tienda()

func abrir_tienda():
    print("El comerciante te observa desde la oscuridad...")
    #aca igusl es donde deberia estar la gui  y todo 


func intentar_comprar_objeto(jugador: Player, objeto_a_comprar: Objeto, precio: int):
    # Verificamos que tenga plata
    if not jugador.tiene_oro_suficiente(precio):
        print("El comerciante te rechaza: No tienes oro.")
        return
        
    #  Intentamos entregar el objeto
    var se_pudo_guardar = jugador.recibir_objeto(objeto_a_comprar)
    
    #  Solo si el jugador pudo guardarlo (mochila no llena), cobramos
    if se_pudo_guardar:
        jugador.gastar_oro(precio)
        print("Transacción exitosa. El comerciante ríe.")
    else:
        print("No puedes llevar más peso.")




func cerrar_tienda():
    # Lógica para forzar el cierre de la UI si el jugador se aleja caminando
    pass