extends CanvasLayer

@onready var grid_container = $CajaInventario/GridContainer
@onready var caja = $CajaInventario

# Tamaño pequeño — siempre visible en esquina
const TAMANO_MINI  := Rect2(10, -130, 210, 120)
# Tamaño expandido — al presionar M
const TAMANO_GRANDE := Rect2(10, -230, 350, 220)

var expandido := false


func _ready():
	visible = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	Eventos.inventario_completo_actualizado.connect(_on_inventario_actualizado)
	_aplicar_tamano(TAMANO_MINI, false)


func _unhandled_input(event):
	if event.is_action_pressed("abrir_inventario"):
		expandido = !expandido
		_aplicar_tamano(TAMANO_GRANDE if expandido else TAMANO_MINI, true)


func _aplicar_tamano(rect: Rect2, animado: bool):
	if animado:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(caja, "offset_left",   rect.position.x,            0.15)
		tween.parallel().tween_property(caja, "offset_top",    rect.position.y,            0.15)
		tween.parallel().tween_property(caja, "offset_right",  rect.position.x + rect.size.x, 0.15)
		tween.parallel().tween_property(caja, "offset_bottom", rect.position.y + rect.size.y, 0.15)
	else:
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
