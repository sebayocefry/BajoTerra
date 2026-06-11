extends Node2D
class_name Gestor_armas

@onready var sprite_arma = $SpriteArma
@onready var mano = $Mano
@onready var audio_disparo: AudioStreamPlayer2D = $Disparo
@onready var audio_sin_municion: AudioStreamPlayer2D = $SinMunicion
@export var armas_disponibles : Array[Arma] = []

var indice_arma_actual: int = 0
var arma_equipada: Arma

var tiempo_enfriamiento: float = 0.0


func inicializar_armas() -> void:
	if armas_disponibles.size() > 0 and armas_disponibles[0] != null:
		equipar_arma(armas_disponibles[0])


func _process(delta: float) -> void:
	if tiempo_enfriamiento > 0.0:
		tiempo_enfriamiento -= delta
	procesar_disparo(delta)


func procesar_disparo(_delta: float) -> void:
	if not arma_equipada:
		return

	var vector_disparo = Input.get_vector("disparar_izq", "disparar_der", "disparar_arriba", "disparar_abajo")

	if vector_disparo != Vector2.ZERO:
		# Snapping a 4 direcciones: elimina el eje menor
		if abs(vector_disparo.x) > abs(vector_disparo.y):
			vector_disparo.y = 0
		else:
			vector_disparo.x = 0

		vector_disparo = vector_disparo.normalized()

		# Orientamos el arma visualmente
		rotation = vector_disparo.angle()
		sprite_arma.flip_v = vector_disparo.x < 0

		# Disparamos solo si terminó el cooldown
		if tiempo_enfriamiento <= 0.0:
			apretar_gatillo(vector_disparo)


func apretar_gatillo(direccion: Vector2) -> void:
	tiempo_enfriamiento = arma_equipada.cadencia
	var jugador := owner as Player
	if jugador and jugador.mana >= arma_equipada.costo_mana:
		audio_disparo.play()
		Eventos.sacudir_camara.emit(1.5, 0.08) # Pequeño temblor al disparar
	else:
		audio_sin_municion.play()
	arma_equipada.disparar(jugador, direccion, mano.global_position)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			cambiar_arma(1)


func cambiar_arma(direccion: int):
	if armas_disponibles.size() <= 1:
		return

	indice_arma_actual += direccion
	if indice_arma_actual >= armas_disponibles.size():
		indice_arma_actual = 0
	elif indice_arma_actual < 0:
		indice_arma_actual = armas_disponibles.size() - 1

	# Mostrar el brazo la primera vez que el jugador cambia de arma
	var jugador := owner as Player
	if is_instance_valid(jugador) and is_instance_valid(jugador.brazo_arma):
		jugador.brazo_arma.visible = true

	equipar_arma(armas_disponibles[indice_arma_actual])


func equipar_arma(nueva_arma: Arma):
	arma_equipada = nueva_arma
	sprite_arma.visible = false
	tiempo_enfriamiento = arma_equipada.cadencia
	Eventos.arma_equipada_cambiada.emit(arma_equipada.icono)
	# Actualizar brazo del jugador con los datos del arma equipada
	var jugador := owner as Player
	if is_instance_valid(jugador):
		jugador.aplicar_datos_brazo(arma_equipada)
