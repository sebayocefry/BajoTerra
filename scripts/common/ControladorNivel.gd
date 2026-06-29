extends Node2D

class_name ControladorNivel

var _puerta: Node = null
var _nombre_escena: String = ""
var _enemigos_vivos: int = 0


func _ready():
	await get_tree().process_frame
	_nombre_escena = get_parent().scene_file_path
	_puerta = _encontrar_puerta()

	var enemigos = _obtener_enemigos()

	if DatosJugador.habitaciones_limpias.get(_nombre_escena, false):
		for e in enemigos:
			if e.has_signal("entidad_morir"):
				e.queue_free()
		if _puerta:
			_puerta.desbloquear()
		return

	# Filtrar los que realmente son enemigos (por si arrastraron otros nodos por error)
	var verdaderos_enemigos = []
	for e in enemigos:
		if e.has_signal("entidad_morir"):
			verdaderos_enemigos.append(e)

	_enemigos_vivos = verdaderos_enemigos.size()
	if _enemigos_vivos > 0:
		if _puerta:
			_puerta.bloquear()
		for e in verdaderos_enemigos:
			if not e.is_connected("entidad_morir", _on_enemigo_muerto):
				e.entidad_morir.connect(_on_enemigo_muerto)
	else:
		if _puerta:
			_puerta.desbloquear()


func _on_enemigo_muerto() -> void:
	_enemigos_vivos -= 1
	if _enemigos_vivos <= 0:
		DatosJugador.habitaciones_limpias[_nombre_escena] = true
		if _puerta:
			_puerta.desbloquear()


func _encontrar_puerta() -> Node:
	var nodo_puertas = get_parent().find_child("Puertas", true, false)
	if not nodo_puertas:
		push_warning("ControladorNivel: No existe el nodo 'Puertas' en '%s'." % _nombre_escena)
		return null

	for hijo in nodo_puertas.get_children():
		if hijo.has_method("bloquear") and hijo.has_method("desbloquear"):
			return hijo

	push_warning("ControladorNivel: Ningún hijo de 'Puertas' tiene bloquear/desbloquear en '%s'." % _nombre_escena)
	return null


func _obtener_enemigos() -> Array:
	var nodo_enemigos = get_parent().find_child("Enemigos", true, false)
	if not nodo_enemigos:
		return []
	return nodo_enemigos.get_children()
