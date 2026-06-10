extends Node


var vida_actual : int = 100
var mana_actual : int = 0
var oro_actual : int = 0
var inventario : Array = [] 

# Memoria falsa o espacial: {"res://habitacion_1.tscn": true, "res://habitacion_2.tscn": true}
# guardamos como los datos de la habitacion como en un diccionario asi no se pierden las cosas, esto
#pasa como 1 frame antesd de salire de la habitacion
var habitaciones_limpias : Dictionary = {}

# Habitación de retorno tras una escena historia standalone.
# GestorNivel la lee al arrancar y arranca desde ahí en vez de habitacion_inicial.
var habitacion_resume: String = ""
var spawn_resume: String = "spawn_entrada"

func guardar_estado_jugador(player: Player):
	print("--- INICIANDO EXTRACCIÓN DE DATOS ---")
	
	# Extraemos uno por uno para ver cuál hace crashear el juego
	vida_actual = player.vida
	print("Vida extraída: ", vida_actual)
	
	mana_actual = player.mana
	print("Maná extraído: ", mana_actual)
	
	oro_actual = player.oro
	print("Oro extraído: ", oro_actual)
	
	inventario = player.gestor_inventario.listaObjetos.duplicate()
	print("Inventario duplicado. Cantidad de objetos: ", inventario.size())
	
	print("--- EXTRACCIÓN EXITOSA, PASANDO A SISTEMA GUARDADO ---")
func cargar_estado_jugador(player: Player):
	player.vida = vida_actual
	player.mana = mana_actual
	player.oro = oro_actual
	player.gestor_inventario.listaObjetos = inventario.duplicate()
	
	
	Eventos.vida_actualizada.emit(player.vida, 100) 
	Eventos.mana_actualizado.emit(player.mana)
	Eventos.oro_actualizado.emit(player.oro)


# Prepara los datos para ser guardados en disco
func obtener_datos_diccionario() -> Dictionary:
	var inventario_rutas = []

	for item in inventario:
		if item != null:
			inventario_rutas.append(item.resource_path)
		else:
			inventario_rutas.append("") 

	return {
		"vida_actual": vida_actual,
		"mana_actual": mana_actual,
		"oro_actual": oro_actual,
		"habitaciones_limpias": habitaciones_limpias,
		"inventario_rutas": inventario_rutas,
		"ultima_escena": get_tree().current_scene.scene_file_path, # Guardamos donde estabamos
		"habitacion_resume": habitacion_resume
	}

# Restaura los datos leidos desde el disco
func cargar_datos_diccionario(datos: Dictionary):
	vida_actual = datos.get("vida_actual", 100)
	mana_actual = datos.get("mana_actual", 0)
	oro_actual = datos.get("oro_actual", 0)
	habitaciones_limpias = datos.get("habitaciones_limpias", {})
	habitacion_resume = datos.get("habitacion_resume", "")
	
	inventario.clear()
	var rutas = datos.get("inventario_rutas", [])
	for ruta in rutas:
		if ruta != "":
			inventario.append(load(ruta)) # Volvemos a cargar el Resource en memoria
		else:
			inventario.append(null)
