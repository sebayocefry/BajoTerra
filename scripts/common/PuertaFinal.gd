extends Area2D
class_name PuertaFinal

# Puerta especial: al cruzarla lanza la cinemática de fin de juego.
# Implementa bloquear/desbloquear para ser compatible con ControladorNivel.

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

	# Evitar doble disparo
	bloqueada = true
	set_deferred("monitoring", false)

	# El cambio de escena se delega al autoload LevelTransition para evitar que
	# la corrutina sea interrumpida si este nodo es liberado durante el fade.
	LevelTransition.ir_a_escena_final()
