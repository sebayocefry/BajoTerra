extends Node


var vida_actual : int = 100
var mana_actual : int = 100
var oro_actual : int = 0
var inventario : Array = [] 
var partida_iniciada: bool = false

# Memoria falsa o espacial: {"res://habitacion_1.tscn": true, "res://habitacion_2.tscn": true}
# guardamos como los datos de la habitacion como en un diccionario asi no se pierden las cosas, esto
#pasa como 1 frame antesd de salire de la habitacion
var habitaciones_limpias : Dictionary = {}

# Habitación de retorno tras una escena historia standalone.
# GestorNivel la lee al arrancar y arranca desde ahí en vez de habitacion_inicial.
var habitacion_resume: String = ""
var spawn_resume: String = "spawn_entrada"

func guardar_estado_jugador(player: Node):
	print("--- INICIANDO EXTRACCIÓN DE DATOS ---")
	partida_iniciada = true
	
	# Extraemos uno por uno para ver cuál hace crashear el juego
	vida_actual = player.vida
	print("Vida extraída: ", vida_actual)
	
	mana_actual = player.mana
	print("Maná extraído: ", mana_actual)
	
	oro_actual = player.oro
	print("Oro extraído: ", oro_actual)
	
	if "gestor_inventario" in player and player.gestor_inventario != null:
		inventario = player.gestor_inventario.listaObjetos.duplicate()
		print("Inventario duplicado. Cantidad de objetos: ", inventario.size())
	
	print("--- EXTRACCIÓN EXITOSA, PASANDO A SISTEMA GUARDADO ---")
func cargar_estado_jugador(player: Node):
	if not partida_iniciada:
		# Es una partida nueva recién creada. Respetamos los stats iniciales del inspector!
		vida_actual = player.vida
		mana_actual = player.mana
		oro_actual = player.oro
		partida_iniciada = true
		
	player.vida = vida_actual
	player.mana = mana_actual
	player.oro = oro_actual

	if "gestor_inventario" in player and player.gestor_inventario != null:
		# Solo cargamos si el autoload realmente tiene datos de inventario guardados
		if inventario.size() > 0:
			player.gestor_inventario.listaObjetos.assign(inventario.duplicate())

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
	partida_iniciada = true # Marcamos que es una partida cargada
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
