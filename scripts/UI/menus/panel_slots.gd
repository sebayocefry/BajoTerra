extends Control
class_name PanelSlots

# Callback que se llama cuando el jugador elige un slot y la carga fue exitosa
var _callback_cargado: Callable


func configurar(callback: Callable) -> void:
	_callback_cargado = callback


func _ready() -> void:
	set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	_construir_ui()


func _construir_ui() -> void:
	# Fondo semitransparente
	var overlay := ColorRect.new()
	overlay.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	overlay.color = Color(0.0, 0.0, 0.0, 0.80)
	add_child(overlay)

	# Contenedor centrado
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 24)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	# Título
	var titulo := Label.new()
	titulo.text = "Selecciona una Partida"
	titulo.add_theme_font_size_override("font_size", 48)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(titulo)

	# Fila de tarjetas
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 32)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(hbox)

	for i in range(1, SistemaGuardado.TOTAL_SLOTS + 1):
		hbox.add_child(_crear_tarjeta(i))

	# Botón volver
	var volver := Button.new()
	volver.text = "Volver"
	volver.custom_minimum_size = Vector2(220, 52)
	volver.add_theme_font_size_override("font_size", 28)
	volver.pressed.connect(queue_free)
	# Centrar el botón dentro del vbox
	var centro_btn := CenterContainer.new()
	centro_btn.add_child(volver)
	vbox.add_child(centro_btn)


func _crear_tarjeta(slot: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(300, 200)

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 12)
	inner.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(inner)

	# Encabezado del slot
	var lbl_titulo := Label.new()
	lbl_titulo.text = "Partida %d" % slot
	lbl_titulo.add_theme_font_size_override("font_size", 32)
	lbl_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inner.add_child(lbl_titulo)

	# Info del guardado
	var lbl_info := Label.new()
	lbl_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl_info.add_theme_font_size_override("font_size", 22)
	inner.add_child(lbl_info)

	# Botón de acción
	var boton := Button.new()
	boton.custom_minimum_size = Vector2(220, 48)
	boton.add_theme_font_size_override("font_size", 24)
	inner.add_child(boton)

	if SistemaGuardado.hay_guardado(slot):
		var datos: Dictionary = SistemaGuardado.obtener_info_slot(slot)
		var ruta_escena: String = str(datos.get("ultima_escena", ""))
		var zona: String = ruta_escena.get_file().get_basename().replace("_", " ") if ruta_escena != "" else "—"
		var vida: String  = str(datos.get("vida_actual", "?"))
		var oro: String   = str(datos.get("oro_actual", "0"))
		lbl_info.text = "Zona: %s\nVida: %s  Oro: %s" % [zona, vida, oro]
		boton.text = "Cargar"
		boton.pressed.connect(_on_cargar_slot.bind(slot))
	else:
		lbl_info.text = "— Vacío —"
		boton.text    = "Vacío"
		boton.disabled = true

	return panel


func _on_cargar_slot(slot: int) -> void:
	var exito := SistemaGuardado.cargar_partida(slot)
	if exito:
		queue_free()
		if _callback_cargado.is_valid():
			_callback_cargado.call()
	else:
		push_error("PanelSlots: No se pudo cargar el slot %d" % slot)
