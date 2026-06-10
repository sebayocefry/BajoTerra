extends Entidad
class_name EnemigoJefeBrr



@export_group("Vida por fases")
@export var vida_fase_chica : int = 100
@export var vida_fase_demonio : int = 300


@export_group("Configuracion Transformacion")
@export var velocidad_anim_transformacion : float = 1.0

@export var dano_contacto : int = 10
@export var dano_demonio : int = 20

@export var mana_morir : int = 20
@export var distancia_vision : float = 300.0

@export_group("Animaciones Chico")
@export var anim_reposo : String = "chico_idle"
@export var anim_movimiento : String = "chico_correr"
@export var anim_ataque : String = "chico_atacar"

@export_group("Animaciones Demonio")
@export var anim_transformacion : String = "transformacion"
@export var anim_demonio_reposo : String = "demonio_idle"
@export var anim_demonio_movimiento : String = "demonio_correr"
@export var anim_demonio_ataque : String = "demonio_atacar"

@export var escena_cristal : PackedScene

var jugador : Node2D = null
var jugador_en_rango : bool = false
var jugador_en_rango_demonio : bool = false

var fase_demonio : bool = false
var transformandose : bool = false

@onready var animacion : AnimationPlayer = $AnimationPlayer
@onready var sprite_chico : Sprite2D = $Sprite2D
@onready var sprite_demonio : Sprite2D = $SpriteGrande

@onready var colision_chico : CollisionShape2D = $CollisionShape2D
@onready var colision_demonio : CollisionShape2D = $ColisionDemonio

@onready var zona_ataque : Area2D = $Zona_ataque
@onready var zona_ataque_demonio : Area2D = $Zona_ataqueDemonio

@onready var maquina_estados : MaquinaEstadoJefe = $maquina_Estado_2

func _ready():
	super._ready()

	vida_maxima = vida_fase_chica
	vida = vida_fase_chica

	jugador = get_tree().get_first_node_in_group("player")

	activar_forma_chica()

	if jugador:
		print("Jefe encontró jugador: ", jugador.name)
	else:
		print("Jefe NO encontró jugador en grupo player")

func activar_forma_chica():
	fase_demonio = false

	sprite_chico.visible = true
	sprite_demonio.visible = false

	colision_chico.disabled = false
	colision_demonio.disabled = true

	zona_ataque.monitoring = true
	zona_ataque_demonio.monitoring = false

func activar_forma_demonio():
	fase_demonio = true

	sprite_chico.visible = false
	sprite_demonio.visible = true

	colision_chico.disabled = true
	colision_demonio.disabled = false

	zona_ataque.monitoring = false
	zona_ataque_demonio.monitoring = true

	jugador_en_rango = false

func morir():
	if not fase_demonio and not transformandose:
		transformandose = true

		estado_invulnerable = true

		velocity = Vector2.ZERO
		move_and_slide()

		print("El jefe no muere todavía. Empieza transformación.")

		maquina_estados.cambiar_estado("Transformacion")
		return

	print("El jefe muere de verdad.")

	if escena_cristal:
		var nuevo_cristal = escena_cristal.instantiate()
		nuevo_cristal.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", nuevo_cristal)

	super.morir()

func _on_zona_ataque_body_entered(body):
	if body.is_in_group("player"):
		jugador = body
		jugador_en_rango = true
		print("Jugador entró en rango chico")

func _on_zona_ataque_body_exited(body):
	if body.is_in_group("player"):
		jugador_en_rango = false
		print("Jugador salió del rango chico")

func _on_zona_ataque_demonio_body_entered(body):
	if body.is_in_group("player"):
		jugador = body
		jugador_en_rango_demonio = true
		print("Jugador entró en rango demonio")

func _on_zona_ataque_demonio_body_exited(body):
	if body.is_in_group("player"):
		jugador_en_rango_demonio = false
		print("Jugador salió del rango demonio")
