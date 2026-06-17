extends Area2D
class_name PuertaSalidaComerciate

## Puerta de salida de la habitación del comerciante.
## Lee de GestorEscenas.habitacion_post_comerciante el destino configurado
## por la puerta de entrada, permitiendo reutilizar una única escena de comerciante.

@export var spawn_destino := "spawn_entrada"

var bloqueada := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func bloquear() -> void:
	bloqueada = true


func desbloquear() -> void:
	bloqueada = false


func _on_body_entered(body: Node2D) -> void:
	if bloqueada:
		return
	# Ignorar si hay una transición en curso (evita disparo falso al cargar la habitación)
	if LevelTransition.esta_transicionando:
		return
	if not body.is_in_group("player"):
		return
	var destino: String = GestorEscenas.habitacion_post_comerciante
	# Fallback: si la variable global está vacía (p. ej. el jugador llegó por otro camino),
	# deducimos el destino según qué habitaciones del nivel 2 ya fueron limpiadas.
	if destino.is_empty():
		destino = _deducir_destino()
	if destino.is_empty():
		push_warning("PuertaSalidaComerciate: no se pudo determinar la habitación de destino.")
		return
	Eventos.transicion_habitacion_solicitada.emit(destino, spawn_destino)


## Determina a qué habitación final ir basándose en el progreso guardado.
## Si el jugador ya limpió alguna habitación del nivel 2 → va al final del nivel 2.
## De lo contrario → va al final del nivel 1.
func _deducir_destino() -> String:
	for ruta in DatosJugador.habitaciones_limpias.keys():
		if "nivel2" in ruta or "nivel_2" in ruta:
			return "uid://ckhroyywkq5yq"   # habitacionfinal_nivel_2
	return "uid://d0cekv4jra70q"           # habitacion_final_nivel_1
