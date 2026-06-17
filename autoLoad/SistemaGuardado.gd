extends Node

const TOTAL_SLOTS: int = 3
var slot_activo: int = 1

func _ruta_slot(slot: int) -> String:
	return "user://bajoterra_save_%d.json" % slot


func guardar_partida(slot: int = -1) -> void:
	if slot == -1:
		slot = slot_activo
	var datos = DatosJugador.obtener_datos_diccionario()
	var json_string = JSON.stringify(datos, "\t")
	var archivo = FileAccess.open(_ruta_slot(slot), FileAccess.WRITE)
	if archivo:
		archivo.store_string(json_string)
		archivo.close()
	else:
		push_error("SistemaGuardado: No se pudo escribir el slot %d." % slot)


func cargar_partida(slot: int = -1) -> bool:
	if slot == -1:
		slot = slot_activo
	var ruta = _ruta_slot(slot)
	if not FileAccess.file_exists(ruta):
		return false
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	var json_string = archivo.get_as_text()
	archivo.close()
	var json = JSON.new()
	if json.parse(json_string) == OK:
		DatosJugador.cargar_datos_diccionario(json.data)
		slot_activo = slot
		return true
	push_error("SistemaGuardado: JSON corrupto en slot %d." % slot)
	return false


func hay_guardado(slot: int) -> bool:
	return FileAccess.file_exists(_ruta_slot(slot))


func obtener_info_slot(slot: int) -> Dictionary:
	var ruta = _ruta_slot(slot)
	if not FileAccess.file_exists(ruta):
		return {}
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if not archivo:
		return {}
	var json_string = archivo.get_as_text()
	archivo.close()
	var json = JSON.new()
	if json.parse(json_string) == OK:
		return json.data
	return {}
