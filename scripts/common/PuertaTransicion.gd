extends Area2D
class_name PuertaTransicion


@export_file("*.tscn")
var siguiente_habitacion: String

@export var spawn_destino := "spawn_entrada"

var bloqueada := false


func _ready():
	body_entered.connect(_on_body_entered)


func bloquear():
	bloqueada = true


func desbloquear():
	bloqueada = false


func _on_body_entered(body: Node2D):
	if bloqueada:
		return
	# Ignorar si hay una transición en curso (evita disparo falso al cargar la habitación)
	if LevelTransition.esta_transicionando:
		return

	if body.is_in_group("player"):
		Eventos.transicion_habitacion_solicitada.emit(
			siguiente_habitacion,
			spawn_destino
		)
