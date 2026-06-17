extends Control

const RUTA_VIDEO := "res://videos/escena_terminojuego/video_escape.ogv"
const RUTA_LOGO  := "res://assets/fondos_intro/fondo_logo.png"
const RUTA_MENU  := "res://escenas/UI/menus/IU_Principal.tscn"

@onready var video : VideoStreamPlayer = $VideoStreamPlayer
@onready var logo  : TextureRect        = $ImagenLogo
@onready var fondo : ColorRect          = $Fondo

var _saltando := false


func _ready() -> void:
	logo.hide()
	logo.modulate.a = 0.0

	if ResourceLoader.exists(RUTA_LOGO):
		logo.texture = load(RUTA_LOGO)
	else:
		push_warning("PantallaFinal: logo no encontrado en %s" % RUTA_LOGO)

	# Intentar cargar el video (.ogv requerido por Godot 4)
	if ResourceLoader.exists(RUTA_VIDEO):
		video.stream = load(RUTA_VIDEO)
		video.play()
		await video.finished
	else:
		push_warning("PantallaFinal: video no encontrado en %s (¿lo convertiste a .ogv?)" % RUTA_VIDEO)
		video.hide()

	await _mostrar_logo()
	get_tree().change_scene_to_file(RUTA_MENU)


func _mostrar_logo() -> void:
	video.hide()
	logo.show()

	var tween := create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(3.5)
	tween.tween_property(logo, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_SINE)
	await tween.finished


func _unhandled_input(event: InputEvent) -> void:
	# Cualquier tecla o click salta el video e ir al logo
	if _saltando:
		return
	if not (event.is_pressed() and not event.is_echo()):
		return

	if video.is_playing():
		_saltando = true
		video.stop()
		video.hide()
		await _mostrar_logo()
		get_tree().change_scene_to_file(RUTA_MENU)
