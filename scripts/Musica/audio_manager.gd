extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var playlist: Array[AudioStream] = []
var indice_actual: int = 0

func _ready():
	# Conectar la señal para cambiar de canción automáticamente cuando termine
	music_player.finished.connect(_on_music_finished)

# Reproduce una sola canción O una lista entera
func play_music(stream_or_array) -> void:
	if stream_or_array is Array or typeof(stream_or_array) == TYPE_ARRAY:
		playlist = stream_or_array
		if playlist.is_empty(): return
		
		# Si ya estamos tocando esta misma playlist, no la reiniciamos
		if music_player.playing and playlist.has(music_player.stream):
			return
			
		indice_actual = 0
		_play_current_track()
		
	elif stream_or_array is AudioStream:
		playlist = [stream_or_array]
		indice_actual = 0
		_play_current_track()

func _play_current_track():
	var stream = playlist[indice_actual]
	if stream == null: return
	
	if music_player.stream == stream and music_player.playing:
		return
		
	music_player.stream = stream
	music_player.play()

func _on_music_finished():
	if playlist.size() > 1:
		# Pasa a la siguiente canción de la lista
		indice_actual += 1
		if indice_actual >= playlist.size():
			indice_actual = 0 # Vuelve a la primera canción si llegó al final
		
		music_player.stream = playlist[indice_actual]
		music_player.play()
	else:
		music_player.play() # Repite la misma si solo hay una

func stop_music() -> void:
	music_player.stop()
	playlist.clear()
