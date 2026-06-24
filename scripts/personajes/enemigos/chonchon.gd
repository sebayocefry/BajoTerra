extends Enemigo
class_name Chonchon

@export var escena_bola_fuego: PackedScene
@export var dano_bola: int = 10
@export var velocidad_bola: float = 180.0
@export var color_bola: Color = Color(0.4, 1.0, 0.4) # verde, distinto al diablo
@export var escala_bola: float = 0.6 # más pequeña que la del diablo

@onready var sprite_animado: AnimatedSprite2D = $AnimatedSprite2D

var last_direction := "frente"


func _ready():
	super._ready()


func actualizar_direccion(direccion: Vector2):
	if abs(direccion.x) > abs(direccion.y):
		last_direction = "der" if direccion.x > 0 else "izq"
	else:
		last_direction = "frente" if direccion.y > 0 else "arriba"


func actualizar_animacion(estado: String):
	if estado == "attack":
		if sprite_animado.sprite_frames.has_animation("ataque"):
			sprite_animado.play("ataque")
		return
	if sprite_animado.sprite_frames.has_animation(last_direction):
		sprite_animado.play(last_direction)


func disparar():
	if not is_instance_valid(jugador) or not escena_bola_fuego:
		return

	var origen: Vector2 = sprite_animado.global_position
	var dir: Vector2 = (jugador.global_position - origen).normalized()

	var bola: BolaDeFuego = escena_bola_fuego.instantiate()
	get_tree().current_scene.add_child(bola)
	bola.global_position = origen
	bola.dano = dano_bola
	bola.modulate = color_bola
	bola.scale *= escala_bola
	bola.inicializar(dir, velocidad_bola)


func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
	super.recibir_dano(cantidad, vector_empuje)
	if not is_instance_valid(sprite_animado):
		return
	var tween := create_tween()
	tween.tween_property(sprite_animado, "modulate", Color(2.0, 0.3, 0.3), 0.07)
	tween.tween_property(sprite_animado, "modulate", Color.WHITE, 0.18)


func morir():
	velocity = Vector2.ZERO
	set_physics_process(false)
	maquina_estados.set_physics_process(false)

	var col = get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)

	var frames = sprite_animado.sprite_frames
	if frames and frames.has_animation("muerte"):
		sprite_animado.play("muerte")
		await sprite_animado.animation_finished
	else:
		await get_tree().create_timer(0.5).timeout

	super.morir()
