extends Node2D

# Script raíz de Historia 4 (intro nivel 2, sala con zombie).
# El diálogo se dispara al acercarse al MineroZombie (npc_dialogo.gd).
# Al terminar el diálogo se activa el flag dialogo_terminado.
# Solo entonces cruzar SalidaHistoria4 carga nivel_1.tscn y GestorNivel
# reanuda en habitacion_1_nivel_2 (guardado por PuertaHistoriaEscena).

var dialogo_terminado: bool = false

func _ready() -> void:
	LevelTransition.fade_in()
	DialogueManager.dialogue_ended.connect(_on_dialogo_terminado)

func es_zona_pacifica() -> bool:
	return true

func _on_dialogo_terminado(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogo_terminado)
	dialogo_terminado = true

func _on_salida_historia4_body_entered(body: Node2D) -> void:
	if body is Player and dialogo_terminado:
		LevelTransition.ir_a_escena("res://escenas/niveles/nivel1/nivel_1.tscn")
