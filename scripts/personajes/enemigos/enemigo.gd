# Esta será la clase "padre" de los enemigos base con máquinas de estado parecidas.
# Para algún enemigo que tenga un comportamiento demasiado distinto,
# creamos una clase nueva que herede de esta y use lo necesario.
# Ejemplos:
# Comportamiento común: correr y atacar 
# Comportamiento distinto: quieto que lance proyectiles

extends Entidad 
class_name Enemigo

@export var dano_contacto: int = 10
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
		
		# maquina de estado para perseguir por rango de vision
		if distancia < distancia_vision:
			
			var direccion = global_position.direction_to(jugador.global_position)
			
			#las sacamos del padre
			velocity = direccion * velocidad  
		else:
			# Estado: REPOSO (Si el jugador se aleja mucho, el fantasma se detiene), asi no choca contra la pared siempre
			velocity = Vector2.ZERO
		move_and_slide()
	
		var cuerpo_tocando = $Zona_ataque.get_overlapping_bodies()

		for cuerpo in cuerpo_tocando:
			if cuerpo is Player:
				#le manda a la funion de la claswe entidad y esta ve si esta true o false

				cuerpo.recibir_dano(dano_contacto)
	else:

		print("el fantasma no detecta al jugador")
