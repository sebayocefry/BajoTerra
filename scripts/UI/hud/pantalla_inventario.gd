extends CanvasLayer

@onready var grid_container = $CajaInventario/GridContainer
@onready var caja = $CajaInventario

# Tamaño de la caja de inventario, al presionar M (centrada en pantalla)
const TAMANO_GRANDE := Rect2(-384, -256, 768, 512)

var expandido := false


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Eventos.inventario_completo_actualizado.connect(_on_inventario_actualizado)
	_aplicar_tamano(TAMANO_GRANDE)
	caja.visible = false
	caja.modulate.a = 0.0


func _unhandled_input(event):
	if event.is_action_pressed("abrir_inventario"):
		expandido = !expandido
		caja.visible = true
		var tween = create_tween()
		tween.tween_property(caja, "modulate:a", 1.0 if expandido else 0.0, 0.15)
		if not expandido:
			tween.tween_callback(func(): caja.visible = false)


func _aplicar_tamano(rect: Rect2):
	caja.offset_left   = rect.position.x
	caja.offset_top    = rect.position.y
	caja.offset_right  = rect.position.x + rect.size.x
	caja.offset_bottom = rect.position.y + rect.size.y


func _on_inventario_actualizado(lista_objetos: Array):
	var slots = grid_container.get_children()
	for i in range(slots.size()):
		var nodo_icono = slots[i].get_node("IconoObjeto")
		if i < lista_objetos.size() and lista_objetos[i] != null:
			nodo_icono.texture = lista_objetos[i].icono
		else:
			nodo_icono.texture = null
