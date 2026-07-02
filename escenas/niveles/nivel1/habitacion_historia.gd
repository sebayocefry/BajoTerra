extends Node2D

# Script raíz de Historia 1.
# Espera a que la Bruja (NPC) termine el diálogo y luego transiciona a nivel_1.
# La transición se delega a LevelTransition (autoload) para que change_scene_to_file
# no interrumpa la corrutina cuando este nodo sea liberado.

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogo_terminado)
	LevelTransition.fade_in()
	await get_tree().process_frame
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		var cam = jugador.get_node_or_null("Camera2D")
		if cam:
			cam.zoom = Vector2(1.016, 1.016)
			cam.limit_left = 4
			cam.limit_top = 6
			cam.limit_right = 1915
			cam.limit_bottom = 1070

func es_zona_pacifica() -> bool:
	return true


func _on_dialogo_terminado(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogo_terminado)
	LevelTransition.ir_a_escena("res://escenas/niveles/nivel1/nivel_1.tscn")
