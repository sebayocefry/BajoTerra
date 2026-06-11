extends CanvasLayer


@onready var color_rect: ColorRect = $ColorRect

var tween_actual : Tween
var esta_transicionando := false


func fade_out() -> void:


	esta_transicionando = true


	if tween_actual:
		tween_actual.kill()


	tween_actual = create_tween()
	tween_actual.set_trans(Tween.TRANS_SINE)


	tween_actual.tween_property(
		color_rect.material,
		"shader_parameter/radius",
		1.2,
		1.0
	)


	await tween_actual.finished



func ir_a_escena(ruta: String) -> void:
	# Solo fade_out + cambio de escena. El destino maneja su propio fade_in
	# (por ejemplo, GestorNivel llama fade_in al terminar de cargar la habitación).
	await fade_out()
	get_tree().change_scene_to_file(ruta)


func ir_a_escena_final() -> void:
	# Se llama desde PuertaFinal. Al ejecutarse en el autoload, el nodo nunca
	# es liberado a mitad de la corrutina, garantizando que change_scene_to_file se ejecute.
	await fade_out()
	get_tree().change_scene_to_file("res://escenas/UI/pantalla_final.tscn")
	await fade_in()


func fade_in() -> void:
	if tween_actual:
		tween_actual.kill()


	tween_actual = create_tween()
	tween_actual.set_trans(Tween.TRANS_SINE)


	tween_actual.tween_property(
		color_rect.material,
		"shader_parameter/radius",
		0.0,
		1.0
	)


	await tween_actual.finished

	esta_transicionando = false
