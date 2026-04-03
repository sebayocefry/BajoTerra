extends CharacterBody2D

class_name Entidad 
#clase padre para jugador, enemigos y todo 
#estos atributos los usaran todos, jugador, enemigos, jefes etc

@export var vida : int = 100
@export var nombre_entidad : String = "npc"
@export var velocidad : int = 100
# Función universal de daño
func recibir_dano(cantidad: int):
	vida -= cantidad
	print(nombre_entidad, " recibió ", cantidad, " de daño. Vida restante: ", vida)
	if vida <= 0:
		morir()

func morir():
	# Cada hijo (Jugador o Enemigo) decide que pasa cuando mueres
	queue_free()