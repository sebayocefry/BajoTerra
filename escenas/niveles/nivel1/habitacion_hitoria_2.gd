extends Node2D

# Script raíz de Historia 2.
# Espera a que la Bruja Zombie (NPC) termine el diálogo y luego transiciona a pantalla_final.
# La transición se delega a LevelTransition (autoload) para seguridad de corrutinas.

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogo_terminado)
	# Limpiar el fade de la transición desde nivel_1 (ir_a_escena hace fade_out pero no fade_in)
	LevelTransition.fade_in()


func _on_dialogo_terminado(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogo_terminado)
	# Volver a nivel_1; GestorNivel leerá DatosJugador.habitacion_resume
	# (ya fue guardado por PuertaHistoriaEscena antes de entrar aquí)
	# y arrancará desde habitacion_3.
	LevelTransition.ir_a_escena("res://escenas/niveles/nivel1/nivel_1.tscn")
