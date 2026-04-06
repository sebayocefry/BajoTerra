# Esta será la clase "padre" de los enemigos base con máquinas de estado parecidas.
# Para algún enemigo que tenga un comportamiento demasiado distinto,
# creamos una clase nueva que herede de esta y use lo necesario.
# Ejemplos:
# Comportamiento común: correr y atacar 
# Comportamiento distinto: quieto que lance proyectiles

extends Entidad 
class_name Enemigo


#atributos del enemigo
@export var dano_contacto: int = 10
@export var mana_morir: int = 20
@export var distancia_vision : float = 300.0
#@export var distancia_ataque : float = 60.0

# nombre de las animaciones 
@export_group("animaciones_enemigo")
@export var anim_reposo : String = "idle"
@export var anim_movimiento :String = "correr"
@export var anim_ataque : String = "atacar"


# Esta variable almacena la referencia al obj jugador para que el enemigo
# entregue el mana al morir y este no se pierda.
var jugador : Entidad = null
# es una referencua al nodo de animaciones 
@onready var animacion: AnimationPlayer = get_node("AnimationPlayer")
#@onready var animacion = $AnimatedSprite2D
@onready var sprite = $Sprite2D


func _ready():
	# Buscamos al jugador en el grupo que creamos antes
	jugador = get_tree().get_first_node_in_group("player")

func morir():
	if jugador:
		jugador.mana += mana_morir
		print("El enemigo murió y le soltó maná al jugador")

	super.morir() # Llamo el método de la clase padre que mata y borra el nodo


#borre lo funcion que le daba comportamientos al enemigo porquew estaba gigante 
#la separe en una arquitectura mas separada y limpia. ya que no tenia sentido haCer una maquina de estado si iba a tener muchos if 
