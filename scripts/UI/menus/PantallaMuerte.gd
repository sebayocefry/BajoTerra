extends CanvasLayer

@export_file("*.tscn") var ruta_menu_principal: String

@onready var boton_reintentar = %BotonReintentar

@onready var boton_menu = %BotonMenuPrincipal # esto se debe corregir cuando tengamos el menu bien hecho 

func _ready():
   
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS # Permite que el boton funcione incluso si el juego esta en PAUSA
	
	
	Eventos.jugador_muerto.connect(_on_jugador_muerto)
	layer = 100 # para que se ponga encima de la ui 
   
	boton_reintentar.pressed.connect(_on_boton_reintentar_pressed)
	boton_menu.pressed.connect(_on_boton_menu_pressed)

func _on_jugador_muerto():
   
	if not visible:
		show()
		get_tree().paused = true

func _on_boton_reintentar_pressed():
	#  Liberamos la pausa antes de la transicion
	get_tree().paused = false 
	
	#  Intentamos la carga desde el sistema del disco
	if SistemaGuardado.cargar_partida():
		print("Carga exitosa. Accediendo a la ultima escena guardada")
		
		# Obtenemos la ruta que guardamos en el JSON
		var datos = DatosJugador.obtener_datos_diccionario()
		var escena_destino = datos.get("ultima_escena", "")
		
		if escena_destino != "":
			# Al ser Autoload, escondemos la pantalla ANTES de cambiar de escena
			hide()
			# Cambiamos a la habitación donde el jugador guardo por ltima vez
			GestorEscenas.cambiar_nivel(escena_destino)
		else:
			hide()
			_fallback_al_menu("Error: 'ultima_escena' no encontrada en el JSON.")
	else:
		_fallback_al_menu("No existe archivo de guardado previo.")

func _on_boton_menu_pressed():
	# no cambiar al menu con el juego pausado o el menu nacera congelado
	get_tree().paused = false 
	
	#  Escondemos la pantalla de muerte
	hide()
	
	
	if ruta_menu_principal != "":
		GestorEscenas.cambiar_nivel(ruta_menu_principal)
	else:
		push_error("Fallo Crítico: No se definió ruta de Menu Principal en el Inspector.")



func _fallback_al_menu(motivo: String):
	push_warning(motivo)
	if ruta_menu_principal != "":
		GestorEscenas.cambiar_nivel(ruta_menu_principal)
	else:
		push_error("Fallo Crítico: No se definio ruta de Menu Principal en el Inspector.")
