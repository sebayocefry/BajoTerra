extends CanvasLayer

@onready var grid_container = $CajaInventario/GridContainer
@onready var caja = $CajaInventario

# Tamaño de la caja de inventario, al presionar M (centrada en pantalla)
const TAMANO_GRANDE := Rect2(-384, -256, 768, 512)

var expandido := false
var cursor_index: int = 0


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
		get_tree().paused = expandido
		var tween = create_tween()
		tween.tween_property(caja, "modulate:a", 1.0 if expandido else 0.0, 0.15)
		if not expandido:
			tween.tween_callback(func(): caja.visible = false)
		else:
			_actualizar_cursor()
		get_viewport().set_input_as_handled()
		return

	if expandido:
		var slots_count = grid_container.get_child_count()
		if event.is_action_pressed("ui_right") or event.is_action_pressed("right"):
			cursor_index = (cursor_index + 1) % slots_count
			_actualizar_cursor()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_left") or event.is_action_pressed("left"):
			cursor_index = (cursor_index - 1 + slots_count) % slots_count
			_actualizar_cursor()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("interactuar") or event.is_action_pressed("ui_accept"):
			_usar_objeto(cursor_index)
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("abrir_inventario") == false and (event.is_action_pressed("ui_focus_next") or event.is_action_pressed("disparar") or event.keycode == KEY_F if event is InputEventKey else false):
			_equipar_objeto(cursor_index)
			get_viewport().set_input_as_handled()


func _actualizar_cursor():
	var slots = grid_container.get_children()
	for i in range(slots.size()):
		if slots[i] is Control:
			slots[i].pivot_offset = slots[i].size / 2.0
			
		if i == cursor_index:
			slots[i].modulate = Color(1.5, 1.5, 1.5, 1.0) # Ilumina el seleccionado
			slots[i].scale = Vector2(1.1, 1.1)
		else:
			slots[i].modulate = Color(0.6, 0.6, 0.6, 1.0) # Oscurece los demas
			slots[i].scale = Vector2(1.0, 1.0)


func _usar_objeto(index: int):
	var player = get_tree().get_first_node_in_group("player")
	if player and "gestor_inventario" in player:
		var gestor = player.gestor_inventario
		if gestor.listaObjetos.size() > index:
			var obj = gestor.listaObjetos[index]
			if obj != null:
				obj.usar(player)
				if obj.get_class() == "Consumible" or obj is Consumible: # Check robusto
					gestor.listaObjetos[index] = null
					gestor.actualizar_ui_objeto()
					Eventos.inventario_completo_actualizado.emit(gestor.listaObjetos)
				print("Objeto usado desde el inventario.")
			else:
				print("Espacio vacio.")


func _equipar_objeto(index: int):
	var player = get_tree().get_first_node_in_group("player")
	if player and "gestor_inventario" in player:
		var gestor = player.gestor_inventario
		if gestor.listaObjetos.size() > index:
			# Lógica inteligente para asignar:
			# Si qa_1 está vacío, llenarlo
			# Si qa_2 está vacío, llenarlo
			# Si ambos están ocupados, sobrescribir el activo
			if gestor.indice_qa_1 == -1 or gestor.indice_qa_1 == index:
				gestor.indice_qa_1 = index
				gestor.qa_activo = 1
			elif gestor.indice_qa_2 == -1 or gestor.indice_qa_2 == index:
				gestor.indice_qa_2 = index
				gestor.qa_activo = 2
			else:
				if gestor.qa_activo == 1:
					gestor.indice_qa_1 = index
				else:
					gestor.indice_qa_2 = index
					
			gestor.actualizar_ui_objeto()
			print("Objeto equipado en el acceso rapido.")


func _aplicar_tamano(rect: Rect2):
	caja.offset_left   = rect.position.x
	caja.offset_top    = rect.position.y
	caja.offset_right  = rect.position.x + rect.size.x
	caja.offset_bottom = rect.position.y + rect.size.y


func _on_inventario_actualizado(lista_objetos: Array):
	var slots = grid_container.get_children()
	for i in range(slots.size()):
		var nodo_icono = slots[i].get_node_or_null("IconoObjeto")
		if nodo_icono:
			if i < lista_objetos.size() and lista_objetos[i] != null:
				nodo_icono.texture = lista_objetos[i].icono
			else:
				nodo_icono.texture = null

