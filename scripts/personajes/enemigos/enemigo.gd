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
@export var distancia_vision : float = 600.0 # Aumentado de 300 a 600
@export var distancia_ataque : float = 60.0 # Descomentado para evitar que se queden pegados

# nombre de las animaciones 
@export_group("animaciones_enemigo")
@export var anim_reposo : String = "idle"
@export var anim_movimiento :String = "correr"
@export var anim_ataque : String = "atacar"

@export var escena_cristal: PackedScene # con esto arrastramo la escena del cistal en el godot
@export var escena_oro: PackedScene # escena del cristal de oro a soltar al morir

# Esta variable almacena la referencia al obj jugador para que el enemigo
# entregue el mana al morir y este no se pierda.
var jugador : Entidad = null
var jugador_en_rango : bool = false
var raycast_vision: RayCast2D

# es una referencua al nodo de animaciones 
@onready var animacion: AnimationPlayer = get_node("AnimationPlayer")
#@onready var animacion = $AnimatedSprite2D
@onready var sprite = $Sprite2D



@onready var maquina_estados = get_node("Maquina_estados") 

func _ready():
	super._ready()
	# Buscamos al jugador en el grupo que creamos antes
	jugador = get_tree().get_first_node_in_group("player")
	
	# Creamos el raycast dinámicamente para no obligar al usuario a editar 20 escenas
	raycast_vision = RayCast2D.new()
	raycast_vision.enabled = false # Lo actualizamos solo cuando lo necesitamos por rendimiento
	raycast_vision.collision_mask = 1 # Asumimos que las paredes están en la capa 1
	add_child(raycast_vision)

func tiene_linea_de_vision() -> bool:
	if not jugador: return false
	
	var distancia = global_position.distance_to(jugador.global_position)
	if distancia > distancia_vision:
		return false
		
	# Apuntamos el rayo hacia el jugador
	raycast_vision.global_position = global_position
	raycast_vision.target_position = raycast_vision.to_local(jugador.global_position)
	raycast_vision.force_raycast_update()
	
	# Si choca con algo (la capa 1, es decir paredes), significa que NO lo puede ver
	# Ojo: si choca, is_colliding() es true. Queremos que devuelva true si NO choca.
	return not raycast_vision.is_colliding()

func es_punto_caminable(punto: Vector2) -> bool:
	# Apuntamos el rayo hacia el punto de destino
	raycast_vision.global_position = global_position
	raycast_vision.target_position = raycast_vision.to_local(punto)
	raycast_vision.force_raycast_update()
	return not raycast_vision.is_colliding()

func morir():
	#ya no suma al morir como orden porque si, ahora solatara el mana bien
	if escena_cristal:
		var nuevo_cristal = escena_cristal.instantiate()
		nuevo_cristal.global_position = global_position
		# agregamos el cristal al mismo contenedor del enemigo (la habitacion)
		get_parent().call_deferred("add_child", nuevo_cristal)

	if escena_oro:
		var nuevo_oro = escena_oro.instantiate()
		nuevo_oro.global_position = global_position
		get_parent().call_deferred("add_child", nuevo_oro)

	super.morir()

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
   
