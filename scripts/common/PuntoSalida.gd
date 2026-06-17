extends Area2D
class_name PuntoSalida

enum TipoSalida { CAMBIO_HABITACION, CAMBIO_NIVEL_FINAL }

@export var tipo_salida: TipoSalida = TipoSalida.CAMBIO_HABITACION
@export_file("*.tscn") var siguiente_nivel: String
var esta_abierta : bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func bloquear():
	esta_abierta = false
	modulate = Color(0.3, 0.3, 0.3)

func desbloquear():
	esta_abierta = true
	modulate = Color(1, 1, 1)

func _on_body_entered(body: Node2D):
	if esta_abierta and body is Player:
		if siguiente_nivel == "":
			push_warning("Salida sin destino configurado.")
			return
			
		if tipo_salida == TipoSalida.CAMBIO_NIVEL_FINAL:
			print("Avanzando al siguiente piso. Reseteando memoria de habitaciones...")
			# Si pasas del Nivel 1 al Nivel 2, ya no puedes volver, así que limpiamos la cache
			DatosJugador.habitaciones_limpias.clear()
			
		GestorEscenas.cambiar_nivel(siguiente_nivel)
