extends Node

class_name Maquina_estados

@export var estado_inicial : NodePath

var estado_actual : Estado

func  _ready():
	#esto le dice que espere para que asi el programa no intente tomar nulos antes de que esten listos
	await owner.ready 
	for hijo in get_children():
		if hijo is Estado:
			hijo.enemigo = owner as Enemigo
			#hijo.animacion = owner.find_child("AnimationPlayer")
			#hijo.sprite = owner.find_child("Sprite2D")
			hijo.animacion = owner.find_child("AnimationPlayer", true, false)
			hijo.sprite = owner.find_child("Sprite2D", true, false)
			#e evento para cambiar de estado
			hijo.transicion.connect(_al_cambiar_estado)


	if estado_inicial:
		estado_actual = get_node(estado_inicial)
		estado_actual.entrar()

#Agregué _process(delta) en la máquina de estados 
#porque algunos estados del Muki no estaban funcionando 
#correctamente usando solo _physics_process().
#El Muki usa varias lógicas visuales y 
#temporaless (hostigamiento, hurt, animaciones y timers async) 
#que no necesariamente dependen de física o movimiento, entonces 
#necesitaba un update normal por frame además del físico.

func _process(delta):

	if estado_actual:

		if estado_actual.has_method("actualizar"):

			estado_actual.actualizar(delta)
			
func _physics_process(delta):
	if estado_actual:
		#print("ESTADO ACTIVO: ", estado_actual.name)
		estado_actual.actualizar_fisica(delta)
		
	else:
		print("ERROR: La máquina no tiene un estado actual")


func _al_cambiar_estado(nuevo_estado_n : String):
	var nuevo_estado = get_node_or_null(nuevo_estado_n)
	if nuevo_estado and nuevo_estado != estado_actual:
		estado_actual.salir()
		estado_actual = nuevo_estado
		estado_actual.entrar()
