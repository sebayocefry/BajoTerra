extends CharacterBody2D

class_name Entidad 
#clase padre para jugador, enemigos y todo 
#estos atributos los usaran todos, jugador, enemigos, jefes etc

@export var vida : int = 100
@export var nombre_entidad : String = "npc"
@export var velocidad : int = 100
#sin export porque no queremos que se modifique en el editor 
var estado_invulnerable : bool = false
var empuje_actual: Vector2 = Vector2.ZERO

# Función universal de daño
func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
    if estado_invulnerable:
        return 
        
    vida -= cantidad
    empuje_actual = vector_empuje
    print(nombre_entidad, " recibió ", cantidad, " de daño. Vida restante: ", vida)
    
    if vida <= 0:
        morir()


func morir():
    queue_free()
	