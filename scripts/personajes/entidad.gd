extends CharacterBody2D

class_name Entidad 
#clase padre para jugador, enemigos y todo 
#estos atributos los usaran todos, jugador, enemigos, jefes etc

@export var vida : int = 100
@export var nombre_entidad : String = "npc"
@export var velocidad : int = 100
#sin export porque no queremos que se modifique en el editor 
var estado_invulnerable : bool = false
# Función universal de daño
func recibir_dano(cantidad: int):
	if estado_invulnerable:
		return #no recibe daño y no ejecuta el resto de codigo
	vida -= cantidad
	print(nombre_entidad, " recibió ", cantidad, " de daño. Vida restante: ", vida)
	if vida <= 0:
		morir()
	else:
		activar_invulnerabilidad(1.0)

func activar_invulnerabilidad(duracion: float):
	estado_invulnerable = true
	# como que el personaje se va a poner transparente por un momento para que se sienta el cambio de estado
	modulate.a = 0.5
	#esto es una promesa, es programacion asincronas
	await get_tree().create_timer(duracion).timeout
	modulate.a = 1.0
	estado_invulnerable = false 
func morir():
	# Cada hijo (Jugador o Enemigo) decide que pasa cuando mueres
	queue_free()