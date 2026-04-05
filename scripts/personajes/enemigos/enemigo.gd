# Esta será la clase "padre" de los enemigos base con máquinas de estado parecidas.
# Para algún enemigo que tenga un comportamiento demasiado distinto,
# creamos una clase nueva que herede de esta y use lo necesario.
# Ejemplos:
# Comportamiento común: correr y atacar 
# Comportamiento distinto: quieto que lance proyectiles

extends Entidad 
class_name Enemigo

@export var dano_contacto: int = 30
@export var mana_morir: int = 20
@export var distancia_vision : float = 300.0

# Esta variable almacena la referencia al obj jugador para que el enemigo
# entregue el mana al morir y este no se pierda.
var jugador : Entidad = null

func _ready():
	# Buscamos al jugador en el grupo que creamos antes
	jugador = get_tree().get_first_node_in_group("player")

func morir():
	if jugador:
		jugador.mana += mana_morir
		print("El enemigo murió y le soltó maná al jugador")

	super.morir() # Llamo el método de la clase padre que mata y borra el nodo

func _physics_process(_delta):
	
	if jugador:
		
		var distancia = global_position.distance_to(jugador.global_position)
		
		# --- EL ARREGLO FiSICO ESTA AQUI ---
		# Definimos la distancia a la que el cuerpo físico debe detenerse.
		# Si el fantasma se frena a 50px, ya no se superpondrán físicamente.
		var distancia_parada_fisica = 50.0 
		
		# 1. Definimos la velocidad basándonos en la distancia.
		
		# Estado A: Te ve, pero esta lo suficientemente lejos para moverse (fuera de 50)
		if distancia < distancia_vision and distancia > distancia_parada_fisica:
			
			var direccion = global_position.direction_to(jugador.global_position)
			# Aplicamos la velocidad que heredas de Entidad
			velocity = direccion * velocidad 
			
		# Estado B: Esta muy lejos (fuera de visión) o YA te alcanzo (a 50 o menos)
		else:
			# Forzamos reposo absoluto
			velocity = Vector2.ZERO

		
		move_and_slide()

	else:
		
		print("esperando al jugador...")
		pass
#el error nunca estuvo en el script sino en la escena, donde los characterBody2d se volvian locos 
#esto porque tomaba fisicas tipo mario y no top down, por lo tanto el motion mode debe ser floatin


func _on_zona_ataque_body_entered(body):
	print('el fantasma toco a ', body.name)
	if body is Player:
		print("se reconoce el cuerpo del jugador")
		body.recibir_dano(dano_contacto)
	else:
		print("el fantsma toco a ", body.name, "pero no lo reonoce como jugador")
	
