extends CanvasLayer

@onready var grid_container = %GridContainer
@onready var boton_salir = %BotonSalir
@onready var label_oro = %LabelOro
@onready var label_mensaje = %LabelMensaje

var comerciante_actual: Comerciante = null
var jugador_actual: Player = null

@export var escena_boton_item: PackedScene

func _ready():
	hide()
	# para que la UI funcione con el juego pausado
	process_mode = Node.PROCESS_MODE_ALWAYS 
	
	Eventos.solicitar_apertura_tienda.connect(_on_solicitar_apertura_tienda)
	boton_salir.pressed.connect(_cerrar_tienda)
	Eventos.oro_actualizado.connect(_actualizar_ui_oro)

func _on_solicitar_apertura_tienda(inventario: Array, comerciante_referencia: Comerciante):
	get_tree().paused = true
	show()
	
	comerciante_actual = comerciante_referencia
	jugador_actual = comerciante_referencia.jugador_en_rango
	
	# Limpieza
	for hijo in grid_container.get_children():
		hijo.queue_free()

	for objeto in inventario:
		if objeto != null:
			var nuevo_item = escena_boton_item.instantiate()
			grid_container.add_child(nuevo_item)
			# Inyectamos la data
			nuevo_item.configurar(objeto)
			
			# Conectamos la señal limpia del componente a la función de compra
			nuevo_item.item_presionado.connect(_on_boton_comprar_presionado)
	_actualizar_ui_oro(jugador_actual.oro)
	

func _actualizar_ui_oro(oro_actual: int):
	label_oro.text = "Oro: " + str(oro_actual)

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
			mostrar_mensaje_feedback("Compraste: " + objeto_seleccionado.nombre, Color.GREEN)
		else:
			#aqui algo para cuando no haya plata
			mostrar_mensaje_feedback("No tienes suficiente oro o espacio.", Color.RED)
			print("UI: Compra rechazada.")

func mostrar_mensaje_feedback(texto: String, color: Color):
	label_mensaje.text = texto
	label_mensaje.add_theme_color_override("font_color", color)
	var tween = create_tween()
	# Hacemos que el texto aparezca altiro
	label_mensaje.modulate.a = 1.0 
	tween.tween_interval(1.5)
	tween.tween_property(label_mensaje, "modulate:a", 0.0, 0.5)

func _cerrar_tienda():
	hide()
	get_tree().paused = false
	comerciante_actual = null
	jugador_actual = null
