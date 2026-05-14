extends Node
class_name Maquina_estados

@export var estado_inicial : NodePath
var estado_actual : Estado

func _ready():
	await owner.ready 
	for hijo in get_children():
		if hijo is Estado:
			hijo.actor = owner as Entidad
			
			if owner is Enemigo:
				hijo.enemigo = owner as Enemigo
			
			# 1. Buscamos quién maneja la animación (puede ser AnimationPlayer o AnimatedSprite2D)
			hijo.animador = owner.find_child("AnimationPlayer")
			if not hijo.animador:
				hijo.animador = owner.find_child("AnimatedSprite2D")
				
			# 2. Buscamos quién maneja los gráficos (puede ser Sprite2D o AnimatedSprite2D)
			hijo.visual = owner.find_child("Sprite2D")
			if not hijo.visual:
				hijo.visual = owner.find_child("AnimatedSprite2D")
				
			hijo.transicion.connect(_al_cambiar_estado)

	if estado_inicial:
		estado_actual = get_node(estado_inicial)
		estado_actual.entrar()

func _process(delta):

	if estado_actual:

		if estado_actual.has_method("actualizar"):

			estado_actual.actualizar(delta)
			
func _physics_process(delta):
	if estado_actual:
		estado_actual.actualizar_fisica(delta)

func _unhandled_input(event):
	if estado_actual:
		estado_actual.manejar_input(event)

func _al_cambiar_estado(nuevo_estado_n : String):
	var nuevo_estado = get_node_or_null(nuevo_estado_n)
	if nuevo_estado and nuevo_estado != estado_actual:
		estado_actual.salir()
		estado_actual = nuevo_estado
		estado_actual.entrar()
