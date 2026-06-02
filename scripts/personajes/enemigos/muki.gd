extends Enemigo

class_name Muki

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var estado_animacion: String = "idle"
var direccion_actual: String = "down"
var muerto := false

@export var radio_hostigamiento: float = 120.0
@export var fuerza_separacion: float = 0.8
@export var distancia_separacion: float = 60.0
@export var fuerza_random: float = 0.15
@export var dano_muki: int = 5


func _ready():
	super._ready()
	add_to_group("mukis")


func _on_zona_ataque_body_entered(body):
	super._on_zona_ataque_body_entered(body)


func _on_zona_ataque_body_exited(body):
	super._on_zona_ataque_body_exited(body)


func reproducir_animacion():
	var nombre = estado_animacion + "_" + direccion_actual
	if animated_sprite.sprite_frames.has_animation(nombre):
		if animated_sprite.animation != nombre:
			animated_sprite.play(nombre)


func actualizar_direccion(vector_direccion: Vector2):
	if vector_direccion.length() < 0.1:
		return
	if abs(vector_direccion.x) > abs(vector_direccion.y):
		direccion_actual = "right" if vector_direccion.x > 0 else "left"
	else:
		direccion_actual = "down" if vector_direccion.y > 0 else "up"
	reproducir_animacion()


func cambiar_estado_animacion(nuevo_estado: String):
	if estado_animacion != nuevo_estado:
		estado_animacion = nuevo_estado
		reproducir_animacion()


# SWARM — separación entre mukis para que no se apilen
func calcular_separacion() -> Vector2:
	var fuerza = Vector2.ZERO
	for muki in get_tree().get_nodes_in_group("mukis"):
		if muki == self:
			continue
		var distancia = global_position.distance_to(muki.global_position)
		if distancia < distancia_separacion:
			fuerza += (global_position - muki.global_position).normalized()
	if fuerza.length() > 0:
		fuerza = fuerza.normalized() * fuerza_separacion
	return fuerza


# SWARM — cada muki orbita al jugador en un ángulo distinto y uniforme
func obtener_posicion_hostigamiento() -> Vector2:
	if jugador == null:
		return global_position
	var mukis = get_tree().get_nodes_in_group("mukis")
	var indice = mukis.find(self)
	var total = max(mukis.size(), 1)
	var angulo_grados = (360.0 / total) * indice
	var offset = Vector2.RIGHT.rotated(deg_to_rad(angulo_grados)) * radio_hostigamiento
	return jugador.global_position + offset


func obtener_movimiento_random() -> Vector2:
	return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * fuerza_random


func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
	if muerto:
		return
	super.recibir_dano(cantidad, vector_empuje)
	# Transiciona al estado Hurt para que el retroceso y la animación se manejen ahí
	if vida > 0 and maquina_estados:
		maquina_estados._al_cambiar_estado("MukiHurt")


func morir():
	if muerto:
		return
	muerto = true

	velocity = Vector2.ZERO
	set_physics_process(false)
	set_process(false)
	if maquina_estados:
		maquina_estados.set_physics_process(false)
		maquina_estados.set_process(false)

	var col = get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)

	# Reproduce la animación de muerte con fallback por timer
	var anim_death = "death_" + direccion_actual
	var frames = animated_sprite.sprite_frames
	if frames and frames.has_animation(anim_death) and not frames.get_animation_loop(anim_death):
		animated_sprite.play(anim_death)
		await animated_sprite.animation_finished
	else:
		var encontrada = ""
		if frames:
			for anim in frames.get_animation_names():
				if "death" in anim and not frames.get_animation_loop(anim):
					encontrada = anim
					break
		if encontrada != "":
			animated_sprite.play(encontrada)
			await animated_sprite.animation_finished
		else:
			await get_tree().create_timer(0.8).timeout

	super.morir()
