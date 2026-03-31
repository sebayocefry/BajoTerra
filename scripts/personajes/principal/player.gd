extends CharacterBody2D

# Atributos del Jugador
#con el @export podemos manipular desde el editor de forma mas visual por si el proyecto crece mucho
@export var Nombre: String = "MineroUcein"
@export var vida: int = 100
@export var mana : int = 0
#el oro en enteros, que se redonde nomas
@export var oro : int = 0
@export var listaObjetos : Array[Objeto] = []

@onready var animation_sprite = $AnimatedSprite2D
# Instanciamos la funcion de movimiento 
@onready var movement = $Movimiento
#codigo automatico generado por godot que sirve para saber donde miraba el personaje 
var last_direction = "down"

func _physics_process(_delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# 1. Delegamos el movimiento al componente
	movement.move(self, input_direction)
	
	# 2. El jugador se encarga de su lógica de animación
	handle_animations(input_direction)

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
