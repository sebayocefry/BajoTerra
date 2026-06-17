extends Control

const PanelSlotsScene = preload("res://scripts/UI/menus/panel_slots.gd")

# ── Nueva Partida ──────────────────────────────────────────────────────────────
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/UI/intro/intro_video.tscn")


# ── Cargar Partida ─────────────────────────────────────────────────────────────
func _on_creditos_pressed() -> void:
	var panel := PanelSlotsScene.new()
	panel.configurar(_iniciar_juego_cargado)
	add_child(panel)


func _iniciar_juego_cargado() -> void:
	# DatosJugador ya tiene los datos cargados; ir directo al juego
	get_tree().change_scene_to_file("res://escenas/niveles/nivel1/nivel_1.tscn")


# ── Salir ──────────────────────────────────────────────────────────────────────
func _on_salir_pressed() -> void:
	get_tree().quit()


# ── Sonidos hover ──────────────────────────────────────────────────────────────
func _on_play_mouse_entered() -> void:
	if not $Boton.playing:
		$Boton.play()

func _on_play_mouse_exited() -> void:
	$Boton.stop()

func _on_creditos_mouse_entered() -> void:
	if not $Boton.playing:
		$Boton.play()

func _on_creditos_mouse_exited() -> void:
	$Boton.stop()

func _on_salir_mouse_entered() -> void:
	if not $Boton.playing:
		$Boton.play()

func _on_salir_mouse_exited() -> void:
	$Boton.stop()
