extends Node2D

# Script raíz de Historia 3 (escena final con el Fantasma).
# Al terminar el diálogo va a la pantalla final en vez de volver a nivel_1.

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogo_terminado)
	LevelTransition.fade_in()
	await get_tree().process_frame
	var jugador = get_tree().get_first_node_in_group("player")
	if jugador:
		var cam = jugador.get_node_or_null("Camera2D")
		if cam:
			cam.zoom = Vector2(1.016, 1.016)
			cam.limit_left = 8
			cam.limit_top = 10
			cam.limit_right = 1910
			cam.limit_bottom = 1165

func es_zona_pacifica() -> bool:
	return true

func _on_dialogo_terminado(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogo_terminado)
	LevelTransition.ir_a_escena_final()
