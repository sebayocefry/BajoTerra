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
var jugador_en_rango : bool = false

# es una referencua al nodo de animaciones 
@onready var animacion: AnimationPlayer = get_node("AnimationPlayer")
#@onready var animacion = $AnimatedSprite2D
@onready var sprite = $Sprite2D



@onready var maquina_estados = get_node("Maquina_estados") 

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

func _on_zona_ataque_body_entered(body: Node2D) -> void:
    if body == jugador:
        jugador_en_rango = true

func _on_zona_ataque_body_exited(body: Node2D) -> void:
    if body == jugador:
        jugador_en_rango = false

func _physics_process(delta):
    # Solo entramos aqui si queremos aplicar el empuje de un golpe recibido
    if empuje_actual != Vector2.ZERO:
        
        # 1. Apagamos el _physics_process del nodo Maquina_estados para que deje de mover al enemigo
        maquina_estados.set_physics_process(false)
        
        # 2. Sobreescribimos la velocidad y aplicamos la física balística
        velocity = empuje_actual
        move_and_slide()
        
        # 3. Fricción para frenar
        empuje_actual = empuje_actual.lerp(Vector2.ZERO, 10 * delta)
        
        # 4. Cuando ya casi no hay empuje, lo cortamos y devolvemos el control
        if empuje_actual.length() < 10:
            empuje_actual = Vector2.ZERO
            
            # Encendemos el cerebro nuevamente. El enemigo retomará el estado en el que estaba.
            maquina_estados.set_physics_process(true)
   