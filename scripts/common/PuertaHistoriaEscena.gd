extends Area2D
class_name PuertaHistoriaEscena

# Puerta especial que lanza una escena "historia" standalone (con su propio jugador).
# Antes de cambiar de escena guarda en DatosJugador en qué habitación debe
# continuar el jugador cuando nivel_1 se recargue al terminar la historia.

@export var escena_historia: String = ""
@export var habitacion_resume: String = ""
@export var spawn_resume: String = "spawn_entrada"

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

	bloqueada = true
	set_deferred("monitoring", false)

	# Guardar en qué habitación debe continuar el jugador al volver a nivel_1
	DatosJugador.habitacion_resume = habitacion_resume
	DatosJugador.spawn_resume = spawn_resume

	# Cambio de escena delegado al autoload para evitar interrupción de corrutina
	LevelTransition.ir_a_escena(escena_historia)
