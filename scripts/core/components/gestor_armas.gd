extends Node2D
class_name Gestor_armas

@onready var sprite_arma = $SpriteArma
@onready var mano = $Mano
@onready var audio_disparo: AudioStreamPlayer2D = $Disparo
@onready var audio_sin_municion: AudioStreamPlayer2D = $SinMunicion
@export var armas_disponibles : Array[Arma] = []
@export var icono_manos_libres: Texture2D

var indice_arma_actual: int = 0
var arma_equipada: Arma

var tiempo_enfriamiento: float = 0.0


func inicializar_armas() -> void:
	var picota = preload("res://recursos/armas/picota.tres")
	if picota and not armas_disponibles.has(picota):
		armas_disponibles.append(picota)
		
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
	var jugador := owner as Player
	if jugador and jugador.mana >= arma_equipada.costo_mana:
		tiempo_enfriamiento = arma_equipada.cadencia
		# La dinamita (y otras armas no disparadas a bala) no usan el sonido de disparo de pistola.
		if not arma_equipada is ArmaLanzable:
			audio_disparo.play()
		Eventos.sacudir_camara.emit(1.5, 0.08) # Pequeño temblor al disparar
		arma_equipada.disparar(jugador, direccion, mano.global_position)
	else:
		audio_sin_municion.play()


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q: # Cambiado de E a Q
			cambiar_arma(1)


func cambiar_arma(direccion: int):
	if armas_disponibles.size() <= 1:
		return

	indice_arma_actual += direccion
	if indice_arma_actual >= armas_disponibles.size():
		indice_arma_actual = 0
	elif indice_arma_actual < 0:
		indice_arma_actual = armas_disponibles.size() - 1

	equipar_arma(armas_disponibles[indice_arma_actual])


func equipar_arma(nueva_arma: Arma):
	arma_equipada = nueva_arma
	sprite_arma.visible = false
	var jugador := owner as Player

	if nueva_arma == null:
		# Manos libres: sin arma, sin brazo visible, sin cooldown.
		tiempo_enfriamiento = 0.0
		Eventos.arma_equipada_cambiada.emit(icono_manos_libres)
		if is_instance_valid(jugador) and is_instance_valid(jugador.brazo_arma):
			jugador.brazo_arma.visible = false
		return

	tiempo_enfriamiento = arma_equipada.cadencia
	Eventos.arma_equipada_cambiada.emit(arma_equipada.icono)
	# Actualizar brazo del jugador con los datos del arma equipada
	if is_instance_valid(jugador):
		jugador.aplicar_datos_brazo(arma_equipada)
