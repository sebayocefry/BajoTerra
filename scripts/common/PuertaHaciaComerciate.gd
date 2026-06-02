extends Area2D
class_name PuertaHaciaComerciate

## Puerta de entrada a la habitación del comerciante.
## Guarda en GestorEscenas a qué habitación volver tras el comerciante,
## de modo que una sola escena de comerciante sirve para todos los niveles.

@export_file("*.tscn") var siguiente_habitacion: String   # habitacion_comerciante.tscn
@export_file("*.tscn") var habitacion_retorno: String     # a dónde ir al salir del comerciante
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
	GestorEscenas.habitacion_post_comerciante = habitacion_retorno
	Eventos.transicion_habitacion_solicitada.emit(siguiente_habitacion, spawn_destino)
