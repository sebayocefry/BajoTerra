extends Node2D

# Script raíz de Historia 1.
# Espera a que la Bruja (NPC) termine el diálogo y luego transiciona a nivel_1.
# La transición se delega a LevelTransition (autoload) para que change_scene_to_file
# no interrumpa la corrutina cuando este nodo sea liberado.

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogo_terminado)


func _on_dialogo_terminado(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogo_terminado)
	LevelTransition.ir_a_escena("res://escenas/niveles/nivel1/nivel_1.tscn")
