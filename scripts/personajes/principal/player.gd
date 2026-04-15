extends Entidad

class_name Player

# Atributos del Jugador
# con el @export podemos manipular desde el editor de forma mas visual por si el proyecto crece mucho
@export var mana : int = 0
# el oro en enteros, que se redonde nomas
@export var oro : int = 0
@export var listaObjetos : Array[Objeto] = []

@onready var animation_sprite = $AnimatedSprite2D
# Instanciamos la funcion de movimiento 
@onready var movement = $Movimiento
# @onready var mano = $Mano
@onready var gestor_armas = $Gestor_armas

var last_direction = "down"

func _ready():
	super._ready()
	await get_tree().process_frame
	# Sincronizamos la UI con los valores iniciales al nacer
	Eventos.vida_actualizada.emit(vida, vida_maxima) 
	Eventos.mana_actualizado.emit(mana)

func _physics_process(_delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# 1. Delegamos el movimiento al componente
	movement.move(self, input_direction)
	
	# 2. El jugador se encarga de su lógica de animación
	handle_animations(input_direction)
	# gestor_armas.actualizar_apuntado(last_direction)

func handle_animations(direction: Vector2):
	if direction == Vector2.ZERO:
		update_animation("idle")
	else:
		# Lógica para determinar last_direction
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"
		
		update_animation("run")

func update_animation(state):
	animation_sprite.play(state + "_" + last_direction)

# este metodo sirve para escuchar cuando el jugador presiona la tecla para usar el objeto del inventario
func _unhandled_input(event):
	# con el ui acept es como un mapa de teclas enter que tiene godot
	# es como cuando usamos el "click" en java, altiro sabe que es
	if event.is_action_pressed("ui_accept"):
		usar_objeto_inventario(0)
	elif event.is_action_pressed("disparar"):
		gestor_armas.apretar_gatillo()

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

# este metodo para manejar la lista del inventario y usar el metodo usar()
func usar_objeto_inventario(indice: int):
	if indice < listaObjetos.size() and listaObjetos[indice] != null:
		var objeto_actual = listaObjetos[indice]
		objeto_actual.usar(self)
		if objeto_actual is Consumible:
			# no elimino de la lista ya que al ser dinamica, de forma visual se achicaria y podria darle 
			# problemas en la interfaz 
			listaObjetos[indice] = null
			print("el objesto se uso y se elimino de la lista ")
			Eventos.consumible_equipado_cambiado.emit(null)
	else:
		print("la mochila esta vacia en ese espacio ")

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