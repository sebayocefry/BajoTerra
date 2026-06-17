extends Control


func _ready():
	$VideoStreamPlayer.stream = load("res://videos/intro/IntroBajoTierra.ogv")
	$VideoStreamPlayer.play()


func _on_video_stream_player_finished():
	_ir_al_juego()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		_ir_al_juego()


func _ir_al_juego():
	get_tree().change_scene_to_file("res://escenas/niveles/nivel1/habitacion_historia.tscn")
