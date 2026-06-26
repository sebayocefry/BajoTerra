extends Node

class_name GestorNivel

@export var habitacion_inicial: String = "res://escenas/niveles/nivel1/habitacion_1_nivel1.tscn"
@export var spawn_inicial: String = "spawn_entrada"
@export var lista_musica: Array[AudioStream] = []

@onready var contenedor_habitaciones = %"ContenedorHabitaciones"
@onready var player = %"Jugador"

var habitacion_actual: Node = null
var transicionando := false


func _ready():
	Eventos.transicion_habitacion_solicitada.connect(_on_transicion_habitacion_solicitada)
	
	# Inicia la lista de reproducción usando las canciones asignadas en el inspector
	if not lista_musica.is_empty():
		AudioManager.play_music(lista_musica)

	# Si venimos de una escena historia standalone, DatosJugador guarda en qué
	# habitación hay que continuar. Lo consumimos aquí y arrancamos desde ahí.
	var inicio := habitacion_inicial
	var spawn := spawn_inicial
	if DatosJugador.habitacion_resume != "":
		inicio = DatosJugador.habitacion_resume
		spawn = DatosJugador.spawn_resume
		DatosJugador.habitacion_resume = ""
		DatosJugador.spawn_resume = "spawn_entrada"

	await cambiar_habitacion(inicio, spawn)


func _on_transicion_habitacion_solicitada(ruta_habitacion: String, spawn_destino: String):
	if transicionando:
		return
	transicionando = true
	await cambiar_habitacion(ruta_habitacion, spawn_destino)


func cambiar_habitacion(ruta_habitacion: String, spawn_destino: String):
	# 1. Bloquear player
	_bloquear_player(true)

	# 2. Fade OUT
	await LevelTransition.fade_out()

	# 3. Eliminar habitación anterior
	if habitacion_actual:
		habitacion_actual.queue_free()
		await get_tree().process_frame

	# 4. Cargar nueva habitación
	var escena_habitacion = load(ruta_habitacion)
	if escena_habitacion == null:
		push_error("GestorNivel: No se pudo cargar: " + ruta_habitacion)
		transicionando = false
		await LevelTransition.fade_in()
		_bloquear_player(false)
		return

	var nueva_habitacion = escena_habitacion.instantiate()
	contenedor_habitaciones.add_child(nueva_habitacion)
	habitacion_actual = nueva_habitacion

	# 5. Posicionar jugador en spawn
	var spawn = nueva_habitacion.find_child(spawn_destino, true, false)
	if spawn:
		player.global_position = spawn.global_position
	else:
		push_warning("GestorNivel: Spawn '%s' no encontrado en %s" % [spawn_destino, ruta_habitacion])

	# 6. Ajustar cámara a los límites de la nueva habitación
	_ajustar_camara(nueva_habitacion)

	# 7. Fade IN
	await LevelTransition.fade_in()

	# 8. Reactivar player
	_bloquear_player(false)
	transicionando = false


func _bloquear_player(bloquear: bool) -> void:
	if bloquear:
		player.velocity = Vector2.ZERO
	player.set_physics_process(not bloquear)
	var maquina = player.get_node_or_null("Maquina_estados")
	if maquina:
		maquina.set_process(not bloquear)
		maquina.set_physics_process(not bloquear)


func _ajustar_camara(habitacion: Node) -> void:
	var cam = player.find_child("Camera2D", true, false) as Camera2D
	if not cam:
		push_warning("GestorNivel: El jugador no tiene Camera2D hija.")
		return

	var rect_nodo = habitacion.find_child("TextureRect", true, false) as TextureRect
	if not rect_nodo:
		push_warning("GestorNivel: La habitación '%s' no tiene TextureRect para calcular límites." % habitacion.name)
		return

	var origen = habitacion.global_position
	cam.limit_left   = int(origen.x + rect_nodo.offset_left)
	cam.limit_right  = int(origen.x + rect_nodo.offset_right)
	cam.limit_top    = int(origen.y + rect_nodo.offset_top) - 50
	cam.limit_bottom = int(origen.y + rect_nodo.offset_bottom)

	# Auto-zoom: si la habitación es más pequeña que el viewport, acercar la cámara
	var ancho = rect_nodo.size.x
	var alto  = rect_nodo.size.y
	if ancho > 0 and alto > 0:
		var viewport_size = get_viewport().get_visible_rect().size
		var zoom_x = viewport_size.x / ancho
		var zoom_y = viewport_size.y / alto
		cam.zoom = Vector2.ONE * maxf(zoom_x, zoom_y)
	else:
		cam.zoom = Vector2.ONE
