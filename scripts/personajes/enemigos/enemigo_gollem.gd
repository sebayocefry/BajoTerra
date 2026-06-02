extends Enemigo

class_name EnemigoGolem

@onready var sprite_animado = $AnimatedSprite2D

var last_direction = "down"
var muerto = false


func _ready():
	super._ready()


func _on_zona_ataque_body_entered(body):
	super._on_zona_ataque_body_entered(body)


func _on_zona_ataque_body_exited(body):
	super._on_zona_ataque_body_exited(body)


func actualizar_direccion(direccion: Vector2):
	if abs(direccion.x) > abs(direccion.y):
		last_direction = "right" if direccion.x > 0 else "left"
	else:
		last_direction = "down" if direccion.y > 0 else "up"


func actualizar_animacion(estado: String):
	var nombre = estado + "_" + last_direction
	var frames = sprite_animado.sprite_frames
	if frames and frames.has_animation(nombre):
		sprite_animado.play(nombre)


func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
	if muerto:
		return
	var vida_anterior = vida
	super.recibir_dano(cantidad, vector_empuje)
	# Solo muestra hurt si sobrevivió al golpe
	if vida < vida_anterior and vida > 0:
		actualizar_animacion("hurt")


func morir():
	if muerto:
		return
	muerto = true

	# Detiene TODO movimiento y física de este nodo y su IA.
	# Importante: apagar set_physics_process del propio golem evita que
	# el knockback de Enemigo reactive la máquina de estados durante el await.
	velocity = Vector2.ZERO
	set_physics_process(false)
	set_process(false)
	maquina_estados.set_physics_process(false)
	maquina_estados.set_process(false)

	# Desactiva colisión para que no siga bloqueando ni dañando
	var col = get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)

	# Reproduce animación de muerte
	var anim_death = "death_" + last_direction
	var frames = sprite_animado.sprite_frames

	if frames and frames.has_animation(anim_death) and not frames.get_animation_loop(anim_death):
		sprite_animado.play(anim_death)
		await sprite_animado.animation_finished
	else:
		# Fallback: busca cualquier animación de muerte sin loop
		var encontrada = ""
		if frames:
			for anim in frames.get_animation_names():
				if "death" in anim and not frames.get_animation_loop(anim):
					encontrada = anim
					break
		if encontrada != "":
			sprite_animado.play(encontrada)
			await sprite_animado.animation_finished
		else:
			await get_tree().create_timer(0.8).timeout

	super.morir()
