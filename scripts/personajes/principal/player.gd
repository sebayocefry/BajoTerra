extends Entidad

class_name Player

# Atributos del Jugador
# con el @export podemos manipular desde el editor de forma mas visual por si el proyecto crece mucho
@export var mana : int = 0
# el oro en enteros, que se redonde nomas
@export var oro : int = 0

@onready var animation_sprite = $AnimatedSprite2D
# Instanciamos la funcion de movimiento 
@onready var movement = $Movimiento
# @onready var mano = $Mano
@onready var gestor_armas = $Gestor_armas
@onready var gestor_inventario = $Gestor_inventario

# NUEVO: Referencia al área que detecta NPCs para que la Máquina de Estados la lea
@onready var detector_npc = $DetectorNPC 

var last_direction = "down"

func _ready():
	super._ready()
	await get_tree().process_frame
	# Sincronizamos la UI con los valores iniciales al nacer
	Eventos.vida_actualizada.emit(vida, vida_maxima) 
	Eventos.mana_actualizado.emit(mana)
	Eventos.oro_actualizado.emit(oro)
	gestor_armas.inicializar_armas()
	gestor_inventario.actualizar_ui_objeto()

func handle_animations(direction: Vector2):
	if direction == Vector2.ZERO:
		update_animation("idle")
	else:
		# Logica para determinar last_direction
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"
		
		update_animation("run")

func update_animation(state):
	animation_sprite.play(state + "_" + last_direction)

func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
	# Guardamos la vida que teníamos antes del golpe
	var vida_anterior = vida
	super.recibir_dano(cantidad, vector_empuje)
	
	# cosas exclusivas del Jugador:
	# Si la vida realmente bajó (no esquivamos el golpe)
	if vida < vida_anterior:
		# Avisamos a la UI de Laura SOLO cuando el Player es herido
		Eventos.vida_actualizada.emit(vida, vida_maxima)
		
		if vida > 0:
			activar_invulnerabilidad(1.0)

func activar_invulnerabilidad(duracion: float):
	estado_invulnerable = true
	# como que el personaje se va a poner transparente por un momento para que se sienta el cambio de estado
	modulate.a = 0.5
	# esto es una promesa, es programacion asincronas
	await get_tree().create_timer(duracion).timeout
	modulate.a = 1.0
	estado_invulnerable = false 

func sumar_mana(cantidad: int):
	mana += cantidad
	# Laura aca te aviso para que escuches el evento 
	Eventos.mana_actualizado.emit(mana)
	# para mi debugg
	print("Maná recogido: +", cantidad, " | Total: ", mana)

func curar(cantidad: int):
	vida += cantidad
	# Esto asegura que la vida nunca supere la vida_maxima de la entidad
	vida = min(vida, vida_maxima) 
	
	Eventos.vida_actualizada.emit(vida, vida_maxima)
	print("Jugador curado: +", cantidad, " | Vida actual: ", vida)

# trate de hacer lo mas limpio posible y quitarle resposabilidades a la clase jugador

# El jugador solo responde si puede o no pagar
func tiene_oro_suficiente(cantidad: int) -> bool:
	return oro >= cantidad

# El jugador solo resta oro e informa a la UI
func gastar_oro(cantidad: int):
	oro -= cantidad
	Eventos.oro_actualizado.emit(oro)

func sumar_oro(cantidad: int):
	oro += cantidad
	Eventos.oro_actualizado.emit(oro)

func morir():
	print("El jugador ha muerto. Iniciando Game Over.")
	Eventos.jugador_muerto.emit()
	
	# Detenemos el proceso fisico para que no pueda moverse ni recibir msa daño mientras cae la pantalla de Game Over
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
