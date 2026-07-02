extends Node2D

# Script raíz de Historia 3 (escena final con el Fantasma).
# Al terminar el diálogo va a la pantalla final en vez de volver a nivel_1.

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogo_terminado)
	LevelTransition.fade_in()

func es_zona_pacifica() -> bool:
	return true

func _on_dialogo_terminado(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogo_terminado)
	LevelTransition.ir_a_escena_final()
