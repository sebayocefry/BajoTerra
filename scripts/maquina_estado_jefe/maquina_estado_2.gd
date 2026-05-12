extends Node
class_name MaquinaEstadoJefe

@export var estado_inicial : NodePath

var estado_actual : EstadoJefe
var enemigo : EnemigoJefeBrr

func _ready():
	enemigo = get_parent() as EnemigoJefeBrr

	if enemigo == null:
		push_error("La máquina de estados debe ser hija de EnemigoJefeBrr")
		return

	await enemigo.ready

	for hijo in get_children():
		if hijo is EstadoJefe:
			hijo.enemigo = enemigo
			hijo.animacion = enemigo.animacion
			hijo.sprite_chico = enemigo.sprite_chico
			hijo.sprite_demonio = enemigo.sprite_demonio

			if not hijo.transicion.is_connected(cambiar_estado):
				hijo.transicion.connect(cambiar_estado)

	if estado_inicial != NodePath(""):
		estado_actual = get_node_or_null(estado_inicial)
	else:
		estado_actual = get_node_or_null("Reposo")

	if estado_actual:
		print("Estado inicial del jefe: ", estado_actual.name)
		estado_actual.entrar()
	else:
		push_error("No hay estado inicial en la máquina del jefe")

func _physics_process(delta):
	if estado_actual:
		estado_actual.actualizar_fisica(delta)

func cambiar_estado(nuevo_estado_nombre : String):
	var nuevo_estado = get_node_or_null(nuevo_estado_nombre)

	if nuevo_estado == null:
		push_error("No existe el estado del jefe: " + nuevo_estado_nombre)
		return

	if nuevo_estado == estado_actual:
		return

	if estado_actual:
		estado_actual.salir()

	print("Jefe cambia de estado: ", estado_actual.name, " -> ", nuevo_estado.name)

	estado_actual = nuevo_estado
	estado_actual.entrar()
