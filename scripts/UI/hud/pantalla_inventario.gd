extends CanvasLayer


@onready var grid_container = $CajaInventario/GridContainer


func _ready():
	# El inventario arranca oculto
	visible = false
	# Procesa input incluso cuando el juego está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	Eventos.inventario_completo_actualizado.connect(_on_inventario_actualizado)


func _unhandled_input(event):
	if event.is_action_pressed("abrir_inventario"):
		visible = !visible
		get_tree().paused = visible


func _on_inventario_actualizado(lista_objetos: Array):
	var slots = grid_container.get_children()

	for i in range(slots.size()):
		var nodo_icono = slots[i].get_node("IconoObjeto")

		if i < lista_objetos.size() and lista_objetos[i] != null:
			nodo_icono.texture = lista_objetos[i].icono
		else:
			nodo_icono.texture = null
