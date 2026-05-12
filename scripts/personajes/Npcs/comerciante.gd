extends StaticBody2D
class_name Comerciante 

#  el array para arrastrar los .tres desde el editor
@export var inventario_tienda: Array[Objeto] = []

var jugador_en_rango: Player = null

signal tienda_solicitada(inventario: Array[Objeto], comerciante: Comerciante)

func _ready():
	assert($ZonaInteraccion != null, "CRiTICO: Falta el nodo ZonaInteraccion (Area2D) en el Comerciante")
	$ZonaInteraccion.body_entered.connect(_on_zona_interaccion_body_entered)
	$ZonaInteraccion.body_exited.connect(_on_zona_interaccion_body_exited)

func _unhandled_input(event):
	if jugador_en_rango and event.is_action_pressed("interactuar"):
		# Lo agregue porque ciando probe en consola me di cuenta que tiraba la señall muchas veces
		get_viewport().set_input_as_handled() 
		abrir_tienda()

func _on_zona_interaccion_body_entered(body: Node2D):
	if body is Player:
		jugador_en_rango = body
		print("Presiona 'E' para comerciar")

func _on_zona_interaccion_body_exited(body: Node2D):
	if body == jugador_en_rango:
		jugador_en_rango = null
		cerrar_tienda()

func abrir_tienda():
	print("El comerciante ")
	Eventos.solicitar_apertura_tienda.emit(inventario_tienda, self)

func intentar_comprar_objeto(jugador: Player, objeto_a_comprar: Objeto):
	var costo = objeto_a_comprar.precio_oro
	
	if not jugador.tiene_oro_suficiente(costo):
		print("El comerciante te rechaza: No tienes oro. Cuesta: ", costo)
		return false
		
	var se_pudo_guardar = jugador.recibir_objeto(objeto_a_comprar)
	
	if se_pudo_guardar:
		jugador.gastar_oro(costo)
		print("Transaccion exitosa")
		return true
	else:
		print("Tu inventario esta lleno.")
		return false

func cerrar_tienda():
	print("Cerrando la UI de la tienda")
	Eventos.cerrar_ui_tienda.emit()

