extends StaticBody2D 

var jugador_cerca: Player = null
@onready var zona_interaccion = $ZonaInteraccion 

func _ready():
	
	zona_interaccion.body_entered.connect(_on_zona_interaccion_body_entered)
	zona_interaccion.body_exited.connect(_on_zona_interaccion_body_exited)

func _unhandled_input(event):
	if jugador_cerca and event.is_action_pressed("interactuar"):
		print("Guardando partida en el NPC...")
		DatosJugador.guardar_estado_jugador(jugador_cerca)
		SistemaGuardado.guardar_partida()

func _on_zona_interaccion_body_entered(body: Node2D):
	if body is Player:
		jugador_cerca = body
		print("Presiona 'E' para guardar partida.")

func _on_zona_interaccion_body_exited(body: Node2D):
	if body == jugador_cerca:
		jugador_cerca = null
