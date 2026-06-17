extends Area2D
class_name Bala

@export var velocidad: float = 400.0
@export var fuerza_impacto : float = 400.0

# Estas variables las reescribe el Arma justo en el milisegundo que la dispara
var direccion: Vector2 = Vector2.ZERO
var dano: int = 0

func _ready():
	# Hace que la bala apunte visualmente hacia donde viaja
	rotation = direccion.angle()
	# Reproducir animación si tiene frames asignados
	var anim: AnimatedSprite2D = $AnimatedSprite2D
	if anim.sprite_frames and anim.sprite_frames.has_animation("default"):
		anim.play("default")

func _physics_process(delta: float):
	# Movimiento constante en la dirección asignada
	position += direccion * velocidad * delta

# Esta señal se dispara cuando la bala toca CUALQUIER cuerpo físico
func _on_body_entered(cuerpo: Node2D):
	# Si la bala toca al Minero por accidente, la ignoramos
	if cuerpo is Player:
		return

	# Duck Typing: Si lo que tocamos sabe recibir daño, se lo hacemos
	# (Esto servirá para enemigos, jefes, ¡o incluso cajas de madera destructibles)
	if cuerpo.has_method("recibir_dano"):
		var direccion_empuje = global_position.direction_to(cuerpo.global_position)
		var vector_fuerza = direccion_empuje * fuerza_impacto
		cuerpo.recibir_dano(dano, vector_fuerza)

	# Si la bala chocó contra CUALQUIER otra cosa
	# (enemigo, muro, piedra, tilemap), se destruye.
	queue_free()

# Borramos la bala al salir de pantalla
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
