extends Entidad

class_name Player

# Atributos del Jugador
@export var mana : int = 100
@export var oro : int = 0

@onready var animation_sprite = $AnimatedSprite2D
@onready var movement = $Movimiento
@onready var gestor_armas = $Gestor_armas
@onready var gestor_inventario = $Gestor_inventario
@onready var brazo_arma: Sprite2D = $BrazoArma

# Datos del brazo — se llenan automáticamente al equipar un arma
var _brazo_texturas: Dictionary = {
	"up": null, "down": null, "left": null, "right": null
}
var _brazo_offsets: Dictionary = {
	"up": Vector2.ZERO, "down": Vector2.ZERO,
	"left": Vector2.ZERO, "right": Vector2.ZERO
}
var _brazo_escala: Vector2 = Vector2.ONE

# Referencia al área que detecta NPCs para que la Máquina de Estados la lea
@onready var detector_npc = $DetectorNPC
@onready var linterna: PointLight2D = $PointLight2D
@onready var audio_herido: AudioStreamPlayer2D = $AudioHerido
@onready var audio_poca_vida: AudioStreamPlayer2D = $AudioPocaVida

var last_direction = "down"
var _tween_linterna: Tween


func _ready():
	super._ready()
	Eventos.sacudir_camara.connect(_sacudir_camara)
	
	# PULL the state from the autoload. This guarantees the player ALWAYS has the correct state.
	DatosJugador.cargar_estado_jugador(self)
	
	await get_tree().process_frame
	# Sincronizamos la UI con los valores iniciales al nacer
	Eventos.vida_actualizada.emit(vida, vida_maxima)
	Eventos.mana_actualizado.emit(mana)
	Eventos.oro_actualizado.emit(oro)
	gestor_armas.inicializar_armas()
	if gestor_inventario:
		gestor_inventario.actualizar_ui_objeto()
	# Orientamos la linterna a la dirección inicial
	_actualizar_linterna(true)
	# Ocultamos el brazo al inicio — aparece al cambiar arma con E
	if is_instance_valid(brazo_arma):
		brazo_arma.visible = false


func handle_animations(direction: Vector2):
	var dir_anterior: String = last_direction
	if direction == Vector2.ZERO:
		update_animation("idle")
	else:
		# Lógica para determinar last_direction
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"
		update_animation("run")
	# Solo actualizamos la linterna y el brazo si cambió la dirección
	if last_direction != dir_anterior:
		_actualizar_linterna(false)
		_actualizar_brazo()


func aplicar_datos_brazo(arma: Arma) -> void:
	_brazo_texturas = {
		"up":    arma.brazo_textura_arriba,
		"down":  arma.brazo_textura_abajo,
		"left":  arma.brazo_textura_izquierda,
		"right": arma.brazo_textura_derecha
	}
	_brazo_offsets = {
		"up":    arma.brazo_offset_arriba,
		"down":  arma.brazo_offset_abajo,
		"left":  arma.brazo_offset_izquierda,
		"right": arma.brazo_offset_derecha
	}
	_brazo_escala = arma.brazo_escala
	_actualizar_brazo()


func _actualizar_brazo() -> void:
	if not is_instance_valid(brazo_arma):
		return
	var nueva_textura = _brazo_texturas.get(last_direction, null)
	brazo_arma.texture = nueva_textura
	
	if nueva_textura == null:
		brazo_arma.visible = false
	else:
		brazo_arma.visible = true
		brazo_arma.position = _brazo_offsets.get(last_direction, Vector2.ZERO)
		brazo_arma.scale = _brazo_escala


func update_animation(state):
	animation_sprite.play(state + "_" + last_direction)


# ── Linterna ──────────────────────────────────────────────────────────────────
# Rota el PointLight2D hacia la dirección actual del jugador.
# instant=true se usa en _ready() para que no haya tween al arrancar.
func _actualizar_linterna(instant: bool = false) -> void:
	if not is_instance_valid(linterna):
		return
	var angulos := {
		"up":    PI,
		"down":  0.0,
		"right": -PI * 0.5,
		"left":  PI * 0.5
	}
	var objetivo: float = angulos.get(last_direction, PI)
	if instant:
		linterna.rotation = objetivo
		return
	if _tween_linterna:
		_tween_linterna.kill()
	_tween_linterna = create_tween()
	_tween_linterna.tween_property(linterna, "rotation", objetivo, 0.12) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
	var vida_anterior = vida
	super.recibir_dano(cantidad, vector_empuje)

	if vida < vida_anterior:
		Eventos.vida_actualizada.emit(vida, vida_maxima)
		audio_herido.play()
		if vida > 0:
			activar_invulnerabilidad(1.0)
		# Latido cuando queda poca vida (menos del 30%)
		if vida <= vida_maxima * 0.3 and not audio_poca_vida.playing:
			audio_poca_vida.play()


func activar_invulnerabilidad(duracion: float):
	estado_invulnerable = true
	modulate.a = 0.5
	await get_tree().create_timer(duracion).timeout
	modulate.a = 1.0
	estado_invulnerable = false


func sumar_mana(cantidad: int):
	mana += cantidad
	Eventos.mana_actualizado.emit(mana)
	DatosJugador.mana_actual = mana
	print("Maná recogido: +", cantidad, " | Total: ", mana)


func curar(cantidad: int):
	vida += cantidad
	vida = min(vida, vida_maxima)
	Eventos.vida_actualizada.emit(vida, vida_maxima)
	DatosJugador.vida_actual = vida
	print("Jugador curado: +", cantidad, " | Vida actual: ", vida)


func tiene_oro_suficiente(cantidad: int) -> bool:
	return oro >= cantidad


func gastar_oro(cantidad: int):
	oro -= cantidad
	Eventos.oro_actualizado.emit(oro)
	DatosJugador.oro_actual = oro


func sumar_oro(cantidad: int):
	oro += cantidad
	Eventos.oro_actualizado.emit(oro)
	DatosJugador.oro_actual = oro


# Delegamos al Gestor_inventario
func recibir_objeto(nuevo_objeto: Objeto) -> bool:
	if gestor_inventario:
		return gestor_inventario.recibir_objeto(nuevo_objeto)
	return false


func morir():
	print("El jugador ha muerto. Iniciando Game Over.")
	Eventos.jugador_muerto.emit()
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

# --- SISTEMA DE SCREEN SHAKE ---
var shake_intensidad: float = 0.0
var shake_duracion: float = 0.0
var camara_referencia: Camera2D

func _sacudir_camara(intensidad: float, duracion: float):
	shake_intensidad = intensidad
	shake_duracion = duracion

func _process(delta: float):
	if shake_duracion > 0:
		shake_duracion -= delta
		if not camara_referencia:
			camara_referencia = get_node_or_null("Camera2D")
		
		if camara_referencia:
			camara_referencia.offset = Vector2(
				randf_range(-shake_intensidad, shake_intensidad),
				randf_range(-shake_intensidad, shake_intensidad)
			)
			
		if shake_duracion <= 0 and camara_referencia:
			camara_referencia.offset = Vector2.ZERO
